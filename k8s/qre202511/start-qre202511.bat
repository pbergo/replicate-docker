@echo off
cls
echo ======================================================
echo   STARTING QLIK REPLICATE (MINIKUBE)
echo ======================================================

:: 1. Verifying if Minikube is running
echo [1/5] Verificando status do Minikube...
minikube status >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Minikube is not running. Starting...
    minikube start
) else (
    echo [OK] Minikube is already operational.
)

:: 2. Mount host folder 
echo [2/5] Mounting Data Folder...
echo ATENCAO: Don´t close window now!
start "Minikube Mount" minikube mount /replicate/qre202511/data:/replicate/qre202511/data

:: 3. Apllying Storage configurations...
echo [3/5] Applying Storage (PV e PVC)...
kubectl apply -f qre202511-pv.yaml
kubectl apply -f qre202511-pvc.yaml

:: 4. Applying Workloads (Deployment e Service)...
echo [4/5] Applying Workloads (Deployment e Service)...
REM kubectl apply -f qre202511-dpl.yaml
kubectl apply -f qre202511-svi.yaml
kubectl apply -f qre202511-svc.yaml
kubectl apply -f qre202511-sts.yaml

:: 5. Waiting for the Pod to initialize...
echo [5/5] Waiting for the Pod to initialize...
timeout /t 10 /nobreak >nul

echo ======================================================
echo   SUCCESS! Opening Qlik Replicate interface...
echo ======================================================
minikube service qre202511-svc

pause