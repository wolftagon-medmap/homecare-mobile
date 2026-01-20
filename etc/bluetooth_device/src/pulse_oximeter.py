import asyncio
import argparse
from bless import BlessServer, GATTCharacteristicProperties, GATTAttributePermissions

# Bluetooth SIG Standard UUIDs
PLX_SERVICE_UUID = "00001822-0000-1000-8000-00805f9b34fb"
PLX_SPOT_CHECK_UUID = "00002a5e-0000-1000-8000-00805f9b34fb"
PLX_CONTINUOUS_UUID = "00002a5f-0000-1000-8000-00805f9b34fb"

# Device Information Service
DIS_SERVICE_UUID = "0000180a-0000-1000-8000-00805f9b34fb"
MANUFACTURER_NAME_UUID = "00002a29-0000-1000-8000-00805f9b34fb"

# Battery Service
BATTERY_SERVICE_UUID = "0000180f-0000-1000-8000-00805f9b34fb"
BATTERY_LEVEL_UUID = "00002a19-0000-1000-8000-00805f9b34fb"

def to_sfloat(value):
    # SFLOAT: 16-bit (4 exp, 12 mantissa)
    mantissa = int(value) & 0x0FFF
    return mantissa.to_bytes(2, byteorder='little')

async def run_simulator(mode):
    loop = asyncio.get_running_loop()
    
    server = BlessServer(name="Nonin SpO2 1234", loop=loop)
    
    print(f"--- Starting Pulse Oximeter ({mode}) ---")
    
    try:
        # 1. Device Info
        # await server.add_new_service(DIS_SERVICE_UUID)
        # await server.add_new_characteristic(
        #     DIS_SERVICE_UUID, MANUFACTURER_NAME_UUID,
        #     GATTCharacteristicProperties.read, 
        #     b"Nonin Medical", 
        #     GATTAttributePermissions.readable
        # )

        # 2. PLX Service
        await server.add_new_service(PLX_SERVICE_UUID)
        
        # Add characteristics based on mode
        # Note: A real device might have both, but we simulate behavior here.
        if mode == 'continuous':
            await server.add_new_characteristic(
                PLX_SERVICE_UUID, PLX_CONTINUOUS_UUID,
                GATTCharacteristicProperties.notify, None, GATTAttributePermissions.readable
            )
        else:
            await server.add_new_characteristic(
                PLX_SERVICE_UUID, PLX_SPOT_CHECK_UUID,
                GATTCharacteristicProperties.indicate, None, GATTAttributePermissions.readable
            )

        # 3. Battery
        await server.add_new_service(BATTERY_SERVICE_UUID)
        await server.add_new_characteristic(
            BATTERY_SERVICE_UUID, BATTERY_LEVEL_UUID,
            GATTCharacteristicProperties.read | GATTCharacteristicProperties.notify,
            b"\x58", GATTAttributePermissions.readable
        )
        
        await server.start()
        print(f" -> Advertising as 'Nonin SpO2 1234'")
        print(f" -> Mode: {mode}")
        
    except Exception as e:
        print(f"CRITICAL ERROR: {e}")
        return

    spo2 = 98
    pulse = 70
    
    try:
        if mode == 'continuous':
            while True:
                # Flags: 0x00 (No Timestamp, No Status, etc)
                # SpO2 (SFLOAT), Pulse (SFLOAT)
                payload = bytearray([0x00])
                payload.extend(to_sfloat(spo2))
                payload.extend(to_sfloat(pulse))
                
                server.get_characteristic(PLX_CONTINUOUS_UUID).value = payload
                server.update_value(PLX_SERVICE_UUID, PLX_CONTINUOUS_UUID)
                
                print(f"PLX >> SpO2: {spo2}% | Pulse: {pulse} BPM")
                await asyncio.sleep(1)
                
                # Fluctuate
                spo2 = 96 + (spo2 + 1) % 4
                pulse = 68 + (pulse + 1) % 5
                
        else: # spot-check
            print(" -> Calculating stable reading (5s)...")
            await asyncio.sleep(5)
            
            payload = bytearray([0x00])
            payload.extend(to_sfloat(spo2))
            payload.extend(to_sfloat(pulse))
            
            server.get_characteristic(PLX_SPOT_CHECK_UUID).value = payload
            server.update_value(PLX_SERVICE_UUID, PLX_SPOT_CHECK_UUID)
            
            print(f"PLX >> Indication Sent: SpO2: {spo2}% | Pulse: {pulse} BPM")
            print(" -> Measurement Complete.")
            
            await asyncio.sleep(60) # Stay alive
            
    except asyncio.CancelledError:
        await server.stop()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--mode', choices=['continuous', 'spot-check'], default='continuous')
    args = parser.parse_args()
    
    try:
        asyncio.run(run_simulator(args.mode))
    except KeyboardInterrupt:
        print("\nSimulator stopped.")