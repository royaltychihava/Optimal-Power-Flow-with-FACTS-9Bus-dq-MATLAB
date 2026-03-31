# Optimal Power Flow with FACTS Devices (9-Bus System)

## Overview
This project implements an optimal power flow (OPF) algorithm for a 9-bus power system with integrated FACTS devices. The system is modeled in dq-coordinates and solved using MATLAB’s `fmincon` to minimize total system cost while satisfying voltage and line flow constraints.

---

## Objective
- Minimize total system cost (generation, losses, FACTS devices)  
- Maintain bus voltage limits  
- Ensure line flow limits are not exceeded  
- Determine optimal placement and operation of FACTS devices  

---

## System Configuration

### 9-Bus Network
![Network](01_9bus_network.png)

- Standard 9-bus benchmark system  
- Used for optimal power flow analysis  

---

### Line Connectivity
![Line Data](02_line_connections.png)

- Defines network topology  
- Used to construct system matrices  

---

## FACTS Device Placement

- **STATCOM (Bus 8)**  
  - Provides reactive power support  
  - Regulates bus voltage  

- **SSSC (Line 4–5)**  
  - Controls power flow  
  - Prevents overloading  

---

## Mathematical Model

### dq-Domain Representation
![M-Matrix](03_m_matrix_dq_model.png)

- System equations formulated in dq-coordinates  
- M-matrix links:
  - Branch currents  
  - Bus currents  
  - Bus voltages  

---

### System Dimensions

- M-matrix: **90 × 144**  
- Unknown variables: **144**  
- Additional equations required: **54**

These are obtained from:
- **18 equations** from bus constraints (PQ, PV, slack buses)  
- **36 equations** from FACTS device voltage conditions  

---

## Optimization Formulation

### Objective Function

The total cost includes:
- Generator costs  
- Transmission losses  
- STATCOM cost  
- SSSC cost  

---

### Constraints

- Power balance at each bus  
- Voltage limits: `1.02 ≤ V ≤ 1.05 pu`  
- Line flow limits  
- FACTS operating limits  

---

## Code Implementation

The MATLAB model builds the system, includes FACTS devices, and solves the optimization using `fmincon`.

---

### System Initialization

`nN = 9`, `nB = 9`, `Sb = 100`

- Defines buses and branches  
- Sets per-unit base  

---

### Network Data

`linedata = [1 4 0 0.0576 ... ];`

- Defines:
  - Line connections  
  - Impedances  
  - Ratings  

---

### FACTS Device Modeling

- **STATCOM**
  - Modeled as shunt voltage source  
  - Provides reactive power support  

- **SSSC**
  - Modeled as series voltage source  
  - Controls power flow  

---

### System Matrix

`M = horzcat(vertcat(aux1, aux2), aux3);`

- Combines all equations into dq-domain matrix  

---

### Optimization Solver

`[SOL, fval, exitflag] = fmincon(...)`

- Solves nonlinear constrained optimization  
- `exitflag = 1` confirms convergence  

---

### Objective Function (Cost)

The cost is computed as:

- Generator costs:
  - `C1 = 100 + 10.5P1`
  - `C2 = 110 + 9.85P2`
  - `C3 = 100 + 10P3`

- Loss cost:
  - `C4 = 10 × losses`

- FACTS costs:
  - STATCOM depends on reactive power  
  - SSSC depends on series compensation  

Total cost:
`C = C1 + C2 + C3 + C4 + FACTS costs`

---

### Power Flow Constraints

Example:
`vd(i)iNd(i) + vq(i)iNq(i) = P(i)`

- Ensures power balance  

Also includes:
- Reactive power balance  
- Voltage constraints  
- Bus type conditions  

---

### FACTS Constraints

- STATCOM active power = 0  
- SSSC active power = 0  

Ensures devices only exchange reactive power.

---

### Inequality Constraints

- Voltage limits  
- Line flow limits  
- Device limits (current, voltage, angle)  

---

### Voltage and Power Calculation

`V = sqrt(vd² + vq²)`  
`δ = atan(vq/vd)`

- Computes voltage magnitude and angle  

---

### Loss Calculation

`Losses = sum(SB)`

- Calculates total system losses  

---

## Results

### Voltage Profile
![Voltage Results](04_voltage_results_with_facts.png)

The optimal solution satisfies voltage constraints:

- Voltage range: **1.0230 – 1.0500 pu**  
- Bus 8 reaches upper limit due to STATCOM support  
- PV buses maintain fixed voltage levels  
- All buses remain within limits  

---

### Line Flow Analysis
![Line Flow Results](05_line_flow_results_with_facts.png)

- All line flows remain below limits  
- Maximum flow: **2.0486 pu (line 3–9)**  
- Minimum flow: **0.2729 pu (line 5–7)**  
- SSSC effectively regulates line 4–5  

No overload conditions observed.

---

## Key Insights

- FACTS devices significantly improve system controllability  
- STATCOM enhances voltage stability  
- SSSC redistributes power flow efficiently  
- Optimization minimizes cost while maintaining constraints  
- System operates securely under all conditions  

---

## Tools Used

- MATLAB  

---

## Files

- dq_OPF_with_FACTS_9Bus_fmincon.m  
- Optimal_Power_Flow_with_FACTS_9Bus_Report.pdf  

---

## Conclusion

This project demonstrates that integrating FACTS devices into optimal power flow improves system performance and reduces operating costs. The optimization successfully determines the most economical operating point while maintaining voltage and line flow constraints. The approach is scalable and suitable for larger systems.

---

## Author

Royalty Holyworth Chihava
