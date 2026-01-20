import asyncio
import logging
from bless import BlessServer, GATTCharacteristicProperties, GATTAttributePermissions

# Bluetooth SIG Standard UUIDs
HR_SERVICE_UUID = "0000180d-0000-1000-8000-00805f9b34fb"
HR_CHAR_UUID = "00002a37-0000-1000-8000-00805f9b34fb"

# Device Information Service
DIS_SERVICE_UUID = "0000180a-0000-1000-8000-00805f9b34fb"
MANUFACTURER_NAME_UUID = "00002a29-0000-1000-8000-00805f9b34fb"

# Battery Service
BATTERY_SERVICE_UUID = "0000180f-0000-1000-8000-00805f9b34fb"
BATTERY_LEVEL_UUID = "00002a19-0000-1000-8000-00805f9b34fb"

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("HRM")

async def run_simulator():
    loop = asyncio.get_running_loop()
    
    server = BlessServer(name="Polar H7 7788", loop=loop)
    
    print("--- Starting Heart Rate Monitor (Continuous) ---")
    
    try:
        # 1. Device Information Service
        # await server.add_new_service(DIS_SERVICE_UUID)
        # await server.add_new_characteristic(
        #     DIS_SERVICE_UUID, MANUFACTURER_NAME_UUID,
        #     GATTCharacteristicProperties.read, 
        #     b"Polar Electro Oy", 
        #     GATTAttributePermissions.readable
        # )
        
        # 2. Heart Rate Service
        await server.add_new_service(HR_SERVICE_UUID)
        await server.add_new_characteristic(
            HR_SERVICE_UUID, HR_CHAR_UUID,
            GATTCharacteristicProperties.notify, None, GATTAttributePermissions.readable
        )

        # 3. Battery Service
        await server.add_new_service(BATTERY_SERVICE_UUID)
        await server.add_new_characteristic(
            BATTERY_SERVICE_UUID, BATTERY_LEVEL_UUID,
            GATTCharacteristicProperties.read | GATTCharacteristicProperties.notify,
            b"\x64", GATTAttributePermissions.readable
        )
        
        await server.start()
        print(" -> Advertising as 'Polar H7 7788'")
        print(" -> Manufacturer: Polar Electro Oy")
        
    except Exception as e:
        print(f"CRITICAL ERROR: {e}")
        return

    bpm = 60
    direction = 1
    
    try:
        while True:
            # Payload: Flags (1 byte) + BPM (1 byte)
            # Flags 0x06:
            #   Bit 0 (0) = Heart Rate Value Format is UINT8
            #   Bit 1 (1) = Sensor Contact Status is supported and detected
            #   Bit 2 (1) = Sensor Contact Status (detected)
            #   ... 
            # Note: Bit 1&2 interaction: 
            # 0x06 (0000 0110) -> Bit 1=1 (supported), Bit 2=1 (detected)
            
            flags = 0x06
            payload = bytearray([flags, bpm])
            
            # Notify
            server.get_characteristic(HR_CHAR_UUID).value = payload
            server.update_value(HR_SERVICE_UUID, HR_CHAR_UUID)
            
            print(f"HRM >> {bpm} BPM")
            
            await asyncio.sleep(1)
            
            # Fluctuate between 60 and 100
            bpm += direction * 2
            if bpm >= 100:
                direction = -1
            elif bpm <= 60:
                direction = 1
                
    except asyncio.CancelledError:
        await server.stop()

if __name__ == "__main__":
    try:
        asyncio.run(run_simulator())
    except KeyboardInterrupt:
        print("\nSimulator stopped.")
