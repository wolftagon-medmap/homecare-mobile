import asyncio
from bless import BlessServer, GATTCharacteristicProperties, GATTAttributePermissions

# Bluetooth SIG Standard UUIDs
BP_SERVICE_UUID = "00001810-0000-1000-8000-00805f9b34fb"
BP_MEASUREMENT_UUID = "00002a35-0000-1000-8000-00805f9b34fb"

# Device Information Service
DIS_SERVICE_UUID = "0000180a-0000-1000-8000-00805f9b34fb"
MANUFACTURER_NAME_UUID = "00002a29-0000-1000-8000-00805f9b34fb"

# Battery Service
BATTERY_SERVICE_UUID = "0000180f-0000-1000-8000-00805f9b34fb"
BATTERY_LEVEL_UUID = "00002a19-0000-1000-8000-00805f9b34fb"

def to_sfloat(value):
    # SFLOAT: 16-bit (4 exp, 12 mantissa)
    # Simple case: exponent 0
    mantissa = int(value) & 0x0FFF
    # Exponent 0
    return mantissa.to_bytes(2, byteorder='little')

async def run_simulator():
    loop = asyncio.get_running_loop()
    
    server = BlessServer(name="Omron BP 9900", loop=loop)
    
    print("--- Starting Blood Pressure Monitor (Spot-check) ---")
    
    try:
        # 1. Device Information Service
        # await server.add_new_service(DIS_SERVICE_UUID)
        # await server.add_new_characteristic(
        #     DIS_SERVICE_UUID, MANUFACTURER_NAME_UUID,
        #     GATTCharacteristicProperties.read, 
        #     b"Omron Healthcare", 
        #     GATTAttributePermissions.readable
        # )

        # 2. Blood Pressure Service
        await server.add_new_service(BP_SERVICE_UUID)
        await server.add_new_characteristic(
            BP_SERVICE_UUID, BP_MEASUREMENT_UUID,
            GATTCharacteristicProperties.indicate, None, GATTAttributePermissions.readable
        )

        # 3. Battery Service
        await server.add_new_service(BATTERY_SERVICE_UUID)
        await server.add_new_characteristic(
            BATTERY_SERVICE_UUID, BATTERY_LEVEL_UUID,
            GATTCharacteristicProperties.read | GATTCharacteristicProperties.notify,
            b"\x55", GATTAttributePermissions.readable
        )
        
        await server.start()
        print(" -> Advertising as 'Omron BP 9900'")
        print(" -> Manufacturer: Omron Healthcare")
        
    except Exception as e:
        print(f"CRITICAL ERROR: {e}")
        return

    # Simulation Logic
    systolic = 120
    diastolic = 80
    map_val = 93 # (120 + 2*80)/3 approx
    
    try:
        print(" -> Idle. Waiting 10 seconds to simulate measurement...")
        await asyncio.sleep(10)
        
        print(" -> Taking Measurement...")
        
        # Flags: 0x00 (mmHg, No Timestamp, No Pulse, No UserID, No Status)
        # Note: If we want to send MAP, it is usually included in the structure for 0x2A35.
        # Structure: Flags, Systolic(SFLOAT), Diastolic(SFLOAT), MAP(SFLOAT).
        flags = 0x00
        
        payload = bytearray([flags])
        payload.extend(to_sfloat(systolic))
        payload.extend(to_sfloat(diastolic))
        payload.extend(to_sfloat(map_val))
        
        server.get_characteristic(BP_MEASUREMENT_UUID).value = payload
        server.update_value(BP_SERVICE_UUID, BP_MEASUREMENT_UUID)
        
        print(f"BPM >> Indication Sent: {systolic}/{diastolic} (MAP {map_val})")
        
        # Keep server alive for a bit so client can receive it
        await asyncio.sleep(60) 
            
    except asyncio.CancelledError:
        await server.stop()

if __name__ == "__main__":
    try:
        asyncio.run(run_simulator())
    except KeyboardInterrupt:
        print("\nSimulator stopped.")