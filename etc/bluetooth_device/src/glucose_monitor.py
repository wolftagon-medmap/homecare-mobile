import asyncio
from bless import BlessServer, GATTCharacteristicProperties, GATTAttributePermissions, BlessGATTCharacteristic

# Bluetooth SIG Standard UUIDs
GLUCOSE_SERVICE_UUID = "00001808-0000-1000-8000-00805f9b34fb"
GLUCOSE_MEASUREMENT_UUID = "00002a18-0000-1000-8000-00805f9b34fb"
RACP_UUID = "00002a52-0000-1000-8000-00805f9b34fb"

# Device Information Service
DIS_SERVICE_UUID = "0000180a-0000-1000-8000-00805f9b34fb"
MANUFACTURER_NAME_UUID = "00002a29-0000-1000-8000-00805f9b34fb"

# Battery Service
BATTERY_SERVICE_UUID = "0000180f-0000-1000-8000-00805f9b34fb"
BATTERY_LEVEL_UUID = "00002a19-0000-1000-8000-00805f9b34fb"

def to_sfloat(value):
    mantissa = int(value) & 0x0FFF
    return mantissa.to_bytes(2, byteorder='little')

# Trigger for burst
trigger_burst = asyncio.Event()

def on_write(characteristic: BlessGATTCharacteristic, value: bytes, **kwargs):
    if characteristic.uuid == RACP_UUID:
        # Check for Report All Records (OpCode 0x01, Operator 0x01)
        # Little endian 0x0101 -> bytes [0x01, 0x01]
        if value == b'\x01\x01':
            print("RACP >> Received 'Report All Records'")
            trigger_burst.set()
        else:
            print(f"RACP >> Unknown Command: {value.hex()}")

async def run_simulator():
    loop = asyncio.get_running_loop()
    
    server = BlessServer(name="Roche Gluco 5566", loop=loop)
    server.write_request_func = on_write
    
    print("--- Starting Blood Glucose Simulation (RACP) ---")
    
    try:
        # 1. Device Info
        # await server.add_new_service(DIS_SERVICE_UUID)
        # await server.add_new_characteristic(
        #     DIS_SERVICE_UUID, MANUFACTURER_NAME_UUID,
        #     GATTCharacteristicProperties.read, 
        #     b"Roche Diabetes Care", 
        #     GATTAttributePermissions.readable
        # )

        # 2. Glucose Service
        await server.add_new_service(GLUCOSE_SERVICE_UUID)
        # 2a. Measurement (Notify)
        await server.add_new_characteristic(
            GLUCOSE_SERVICE_UUID, GLUCOSE_MEASUREMENT_UUID,
            GATTCharacteristicProperties.notify, None, GATTAttributePermissions.readable
        )
        # 2b. RACP (Write, Indicate)
        await server.add_new_characteristic(
            GLUCOSE_SERVICE_UUID, RACP_UUID,
            GATTCharacteristicProperties.write | GATTCharacteristicProperties.indicate,
            None, GATTAttributePermissions.writeable | GATTAttributePermissions.readable
        )

        # 3. Battery
        await server.add_new_service(BATTERY_SERVICE_UUID)
        await server.add_new_characteristic(
            BATTERY_SERVICE_UUID, BATTERY_LEVEL_UUID,
            GATTCharacteristicProperties.read | GATTCharacteristicProperties.notify,
            b"\x60", GATTAttributePermissions.readable
        )
        
        await server.start()
        print(" -> Advertising as 'Roche Gluco 5566'")
        print(" -> Waiting for RACP 'Report All Records' (0x0101)...")
        
    except Exception as e:
        print(f"CRITICAL ERROR: {e}")
        return

    try:
        while True:
            await trigger_burst.wait()
            trigger_burst.clear()
            
            print(" -> Bursting 5 records...")
            
            # Base Glucose: 100 mg/dL
            # Format: Flags (0x03: Time Offset + Conc Type/Loc), SeqNum, BaseTime, TimeOffset, Conc(SFLOAT), Type/Loc
            # Simplified for demo: Flags=0x00 (SeqNum + BaseTime + Conc)
            # BaseTime (7 bytes): Year(2), Month(1), Day(1), H, M, S
            
            start_glucose = 100
            
            for i in range(5):
                seq_num = i + 1
                glucose = start_glucose + (i * 5)
                
                # Construct Packet
                # Flags: 0x00 (SeqNum, Time, Conc in kg/L... wait, kg/L is default. 
                # To use mg/dL, Bit 2 must be 0? No, 1=mol/L. 
                # Actually for mg/dL usually we assume conversion or specific context.
                # Let's use simple struct: Flags(0), Seq(2), Time(7), Conc(2).
                
                flags = 0x00
                pkt = bytearray([flags])
                pkt.extend(seq_num.to_bytes(2, 'little'))
                
                # Time: 2023-01-01 12:00:00
                pkt.extend((2023).to_bytes(2, 'little'))
                pkt.extend(bytes([1, 1, 12, 0, i])) # Sec increments
                
                # Conc (SFLOAT)
                # Note: 100 mg/dL. 
                # If we send as-is with exp=0, value=100.
                pkt.extend(to_sfloat(glucose))
                
                server.get_characteristic(GLUCOSE_MEASUREMENT_UUID).value = pkt
                server.update_value(GLUCOSE_SERVICE_UUID, GLUCOSE_MEASUREMENT_UUID)
                
                print(f"   -> Sent Record #{seq_num}: {glucose} mg/dL")
                await asyncio.sleep(0.5)
            
            # Send RACP Success Response
            # OpCode 6 (Response), ReqOpCode 1 (Report Records), Response 1 (Success)
            racp_resp = bytearray([0x06, 0x01, 0x01])
            server.get_characteristic(RACP_UUID).value = racp_resp
            server.update_value(GLUCOSE_SERVICE_UUID, RACP_UUID)
            print(" -> RACP Success Indication Sent.")

    except asyncio.CancelledError:
        await server.stop()

if __name__ == "__main__":
    try:
        asyncio.run(run_simulator())
    except KeyboardInterrupt:
        print("\nSimulator stopped.")