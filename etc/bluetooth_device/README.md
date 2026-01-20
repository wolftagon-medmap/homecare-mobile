# Homecare BLE Simulator

A suite of Python scripts to simulate medical BLE devices using the `bless` library. These simulators adhere to official Bluetooth SIG standard profiles and mimic real-world hardware behaviors (Streaming, Spot-checks, and Database Syncing).

---

## 🧬 Emulated Devices

### 1. Heart Rate Monitor (Continuous)
**Script:** `src/heart_rate_monitor.py`  
**Mimics:** Polar H7 / Polar Electro Oy  
- **Behavior:** Continuous streaming.
- **Service:** Heart Rate (`0x180D`)
- **Characteristic:** Heart Rate Measurement (`0x2A37`) — **Notify**
- **Payload:** 2-byte (Flags: `0x06` + BPM: 60-100).

### 2. Blood Pressure Monitor (Aggregated)
**Script:** `src/blood_pressure_monitor.py`  
**Mimics:** Omron Healthcare  
- **Behavior:** Spot-check. Idles for 10s, then sends one aggregated packet.
- **Service:** Blood Pressure (`0x1810`)
- **Characteristic:** Blood Pressure Measurement (`0x2A35`) — **Indicate**
- **Payload:** SFLOAT triplet (Systolic / Diastolic / MAP).

### 3. Pulse Oximeter (Hybrid)
**Script:** `src/pulse_oximeter.py`  
**Mimics:** Nonin Medical  
- **Behavior:** Supports both Streaming and Spot-check modes.
- **Flag:** `--mode continuous` (Default) or `--mode spot-check`
- **Continuous:** Characteristic `0x2A5F` (Notify). Updates SpO2/Pulse every 1s.
- **Spot-check:** Characteristic `0x2A5E` (Indicate). Calculates for 5s, then sends one packet.

### 4. Blood Glucose Meter (RACP Sync)
**Script:** `src/glucose_monitor.py`  
**Mimics:** Roche Diabetes Care (Accu-Chek)  
- **Behavior:** Database/Burst sync. Silent until triggered via RACP.
- **Service:** Glucose (`0x1808`)
- **Trigger:** Write `0x0101` (Report All Records) to Record Access Control Point (`0x2A52`).
- **Burst:** Rapidly sends 5 historical records via Glucose Measurement (`0x2A18`) followed by a "Success" indication on RACP.

---

## 🛰 Technical Details

- **Device Information Service (`0x180A`):** All scripts implement the Manufacturer Name String (`0x2A29`) characteristic to satisfy app-side brand filtering.
- **Battery Service (`0x180F`):** Provides battery level simulation to test low-power UI warnings.
- **Data Formats:** Uses IEEE-11073 16-bit SFLOAT where required by SIG standards.

---

## 🚀 Setup & Installation
Requires python version 3.10 or 3.11 (Recommended).
Versions higher than that would likely to have incompatibility issue, especially for Windows.

### 1. Create Environment
```bash
python -m venv .venv
# Windows
.\.venv\Scripts\Activate.ps1
# macOS/Linux
source .venv/bin/activate
```

### 2. Install Dependencies
```bash
pip install -e .
```

---

## 🏃 How to Run

Ensure Bluetooth is enabled and you have appropriate permissions (Administrator on Windows, Bluetooth permissions on macOS).

```bash
# Start Heart Rate Monitor
python src/heart_rate_monitor.py

# Start Blood Pressure Monitor
python src/blood_pressure_monitor.py

# Start Pulse Oximeter (Continuous)
python src/pulse_oximeter.py --mode continuous

# Start Blood Glucose Meter
python src/glucose_monitor.py
```

---

## 📚 Reference
- [Bluetooth SIG GATT Services](https://www.bluetooth.com/specifications/specs/)
- [IEEE-11073 SFLOAT Format Guide](https://vscalc.com/ieee-11073-20601-sfloat-converter/)
