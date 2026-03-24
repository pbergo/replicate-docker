@echo off
cls
echo ======================================================
echo   STARTING QLIK REPLICATE (MINIKUBE)
echo ======================================================

:: 1. Verifying if Minikube is running
echo [1/6] Verificando status do Minikube...
minikube status >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Minikube is not running. Starting...
    minikube start
) else (
    echo [OK] Minikube is already operational.
)

:: 2. Mount host folder 
echo [2/6] Mounting Data Folder...
echo ATENCAO: Don´t close window now!
start "Minikube Mount" minikube mount c://qlikfolder//qre202511//data:/replicate/qre202511/data

:: 3. Set the Configuration for the Qlik Replicate
echo [3/6] Setting the configuration files...
kubectl apply -f qre202511-pwd.yaml
kubectl apply -f qre202511-cfg.yaml

:: 3. Apllying Storage configurations...
echo [4/6] Applying Storage (PV e PVC)...
kubectl apply -f qre202511-pv.yaml
kubectl apply -f qre202511-pvc.yaml

:: 4. Applying Workloads (Deployment e Service)...
echo [5/6] Applying Workloads (Deployment e Service)...
REM kubectl apply -f qre202511-dpl.yaml
kubectl apply -f qre202511-svi.yaml
kubectl apply -f qre202511-svc.yaml
kubectl apply -f qre202511-sts.yaml

:: 5. Waiting for the Pod to initialize...
echo [6/6] Waiting for the Pod to initialize...
timeout /t 10 /nobreak >nul

echo ======================================================
echo   SUCCESS! Opening Qlik Replicate interface...
echo ======================================================
minikube service qre202511-svc

pause


kubectl delete all -l app=qre202511
kubectl delete -f qre202511-pvc.yaml
kubectl delete -f qre202511-pv.yaml
kubectl delete -f qre202511-cfg.yaml
kubectl delete -f qre202511-pwd.yaml