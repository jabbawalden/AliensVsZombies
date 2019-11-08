import PlayerFiles.UZCameraActor;
import PlayerFiles.UZLaserBeam;
import PlayerFiles.UZPullBeam;
import GameFiles.UZGameMode;
import WorldFiles.UZPickUpObject;
import PlayerFiles.UZRemoteCannon;
import GameFiles.UZPlayerWidget;
import GameFiles.UZStaticFunctions;

class AUZPlayerMain : APawn
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UStaticMeshComponent MeshComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USpotLightComponent SpotLightComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USphereComponent SphereCompResourceCatch;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USceneComponent SpawnObjectOrigin;

    UPROPERTY(DefaultComponent)
    UFloatingPawnMovement FloatingPawnComp;
    default FloatingPawnComp.MaxSpeed = 1500.f;

    UPROPERTY()
    TSubclassOf<AActor> LaserBeamClass;
    AActor LaserBeamRef;
    AUZLaserBeam LaserBeam;

    UPROPERTY()
    TSubclassOf<AActor> PullBeamClass;
    AActor PullBeamRef;
    AUZPullBeam PullBeam;

    UPROPERTY()
    TSubclassOf<AActor> StunTrapClass;
    AActor StunTrapRef;

    UPROPERTY(DefaultComponent)
    UInputComponent InputComp;

    UPROPERTY(DefaultComponent)
    UUZTraceCheckComp TraceCheckComp;

    UPROPERTY()
    TArray<AUZCameraActor> CameraArray;
    AUZCameraActor CameraObj;

    UPROPERTY()
    TSubclassOf<AActor> RemoteCannonClass;
    AActor RemoteCannonRef;

    UPROPERTY()
    TSubclassOf<UUserWidget> MainWidget;

    UPROPERTY()
    TSubclassOf<UUserWidget> StartWidget;

    //TODO Implement this
    UPROPERTY()
    TSubclassOf<UUserWidget> EndWidget;

    UPROPERTY()
    FLinearColor LightBuildTrue;

    UPROPERTY()
    FLinearColor LightBuildFalse;

    AUZGameMode GameMode;

    APlayerController PlayerController;

    UPROPERTY()
    float SpawnTurretRate = 0.5f;
    float NewSpawnTurretTime; 

    UPROPERTY()
    float SpawnSunTrapRate = 0.5f;
    float NewSpawnStunTrapTime; 

    bool bIsActive;
    bool bLaserOn;
    bool bPullOn;

    UPROPERTY()
    float XLocAllowedMovement = 3200.f;
    UPROPERTY()
    float YLocAllowedMovement = 3000.f;

    UPROPERTY()
    float MeshRotateSpeed = 100.f;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        SphereCompResourceCatch.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode()); 

        if (GameMode == nullptr)
        return;

        PlayerGameModeSetUp();
        PlayerCamSetup();
        PlayerInputSetup();

        if (PlayerController != nullptr)
        {
            AddMainWidgetToHUD(PlayerController, MainWidget);
            AddStartWidgetToHUD(PlayerController, StartWidget);
        }
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        SetMeshRotation(DeltaSeconds);
        SpotLightColor(TraceCheckComp.bIsInRangeOfTarget);
    }
    
    UFUNCTION()
    void StartGame()
    {
        bIsActive = true;

        if (GameMode.StartWidgetReference == nullptr)
        return;

        GameMode.StartWidgetReference.RemoveFromParent(); 
    }

    UFUNCTION()
    void PlayerGameModeSetUp()
    {
        GameMode.EventEndGame.AddUFunction(this, n"DisablePlayerControls");
        GameMode.EventStartGame.AddUFunction(this, n"StartGame");
    }

    UFUNCTION()
    void PlayerCamSetup()
    {
        AUZCameraActor::GetAll(CameraArray);
        PlayerController = Gameplay::GetPlayerController(0);

        if (PlayerController == nullptr)
        return;

        PlayerController.SetViewTargetWithBlend(CameraArray[0], 0.f);
        CameraObj = CameraArray[0];
        if (CameraObj != nullptr)
        {
            CameraObj.GetPlayerReference(this); 
        }

    }

    UFUNCTION()
    void PlayerInputSetup()
    {
        InputComp.BindAction(n"StartButton", EInputEvent::IE_Pressed, FInputActionHandlerDynamicSignature(this, n"StartPressed")); 
        InputComp.BindAxis(n"MoveForward", FInputAxisHandlerDynamicSignature(this, n"MovePForward"));
        InputComp.BindAxis(n"MoveRight", FInputAxisHandlerDynamicSignature(this, n"MovePRight"));
        InputComp.BindAction(n"LaserCannon", EInputEvent::IE_Pressed, FInputActionHandlerDynamicSignature(this, n"LaserCannonOn"));
        InputComp.BindAction(n"LaserCannon", EInputEvent::IE_Released, FInputActionHandlerDynamicSignature(this, n"LaserCannonOff"));
        InputComp.BindAction(n"PullBeam", EInputEvent::IE_Pressed, FInputActionHandlerDynamicSignature(this, n"PullBeamOn"));
        InputComp.BindAction(n"PullBeam", EInputEvent::IE_Released, FInputActionHandlerDynamicSignature(this, n"PullBeamOff"));    
        InputComp.BindAction(n"BuildTurret", EInputEvent::IE_Pressed, FInputActionHandlerDynamicSignature(this, n"SpawnTurret")); 
        InputComp.BindAction(n"BuildStunTrap", EInputEvent::IE_Pressed, FInputActionHandlerDynamicSignature(this, n"SpawnStunTrap")); 
    }

    UFUNCTION()
    void StartPressed(FKey Key)
    {
        if (GameMode == nullptr)
        return;

        if (GameMode.bGameEnded)
        {
            int R = FMath::RandRange(1,6);
            Print("Our Map Index is: " + R, 5.f);
            Gameplay::OpenLevel(UZMaps(R));
        }
        else
        {
            GameMode.StartGame();
        }
    }

    UFUNCTION()
    void MovePForward(float AxisValue)
    {
        if (!bIsActive)
        return;
        
        if (ActorLocation.X > -XLocAllowedMovement && AxisValue < 0)
            AddMovementInput(ControlRotation.ForwardVector, AxisValue);
        else if (ActorLocation.X < XLocAllowedMovement && AxisValue > 0)  
            AddMovementInput(ControlRotation.ForwardVector, AxisValue);
        
    }

    UFUNCTION()
    void MovePRight(float AxisValue)
    {
        if (!bIsActive)
        return;

        if (ActorLocation.Y > -YLocAllowedMovement && AxisValue < 0)
            AddMovementInput(ControlRotation.RightVector, AxisValue); 
        else if (ActorLocation.Y < YLocAllowedMovement && AxisValue > 0)  
            AddMovementInput(ControlRotation.RightVector, AxisValue);       
    }

    UFUNCTION()
    void LaserCannonOn(FKey Key)
    {
        if (!bIsActive)
        return;

        if (!bPullOn)
        {
            LaserBeamRef = SpawnActor(LaserBeamClass, ActorLocation);
            LaserBeam = Cast<AUZLaserBeam>(LaserBeamRef);
            if (LaserBeam != nullptr)
            {
                LaserBeam.SetFollowTarget(this); 
                bLaserOn = true;
            }
        }
    }

    UFUNCTION()
    void LaserCannonOff(FKey Key)
    {
        if (!bIsActive)
        return;

        if (LaserBeam != nullptr)
        {
            LaserBeam.IsActive = false;
            bLaserOn = false;
        }
    }

    UFUNCTION()
    void PullBeamOn(FKey Key)
    {
        if (!bIsActive)
        return;

        if (!bLaserOn)
        {
            PullBeamRef = SpawnActor(PullBeamClass, ActorLocation);
            PullBeam = Cast<AUZPullBeam>(PullBeamRef);

            if (PullBeam != nullptr)
            {
                PullBeam.SetFollowTarget(this); 
                bPullOn = true;
            }
        }
    }

    UFUNCTION()
    void PullBeamOff(FKey Key)
    {
        if (!bIsActive)
        return;

        if (PullBeam != nullptr)
        {
            PullBeam.IsActive = false;
            bPullOn = false;
        }
    }

    UFUNCTION()
    void SpawnTurret(FKey Key)
    {
        if (!TraceCheckComp.bIsInRangeOfTarget)
        return;

        if (GameMode == nullptr)
        return;

        if (!bIsActive)
        return;

        if (GameMode.Resources >= GameMode.TurretCost)
        {
            if (NewSpawnTurretTime <= Gameplay::TimeSeconds)
            {
                NewSpawnTurretTime = Gameplay::TimeSeconds + SpawnTurretRate;
                RemoteCannonRef = SpawnActor(RemoteCannonClass, SpawnObjectOrigin.GetWorldLocation());
                GameMode.AddRemoveResources(-GameMode.TurretCost); 
            }    
        }
    }

    UFUNCTION()
    void SpawnStunTrap(FKey Key)
    {
        if (!TraceCheckComp.bIsInRangeOfTarget)
        return;

        if (GameMode == nullptr)
        return;

        if (!bIsActive)
        return;

        if (GameMode.Resources >= GameMode.StunTrapCost)
        {
            if (NewSpawnStunTrapTime <= Gameplay::TimeSeconds)
            {
                NewSpawnStunTrapTime = Gameplay::TimeSeconds + SpawnSunTrapRate;
                StunTrapRef = SpawnActor(StunTrapClass, SpawnObjectOrigin.GetWorldLocation());
                GameMode.AddRemoveResources(-GameMode.StunTrapCost); 
            }    
        }
    }

    UFUNCTION()
    void SetMeshRotation(float DeltaTime)
    {
        FRotator CurrentMeshRot = MeshComp.GetRelativeRotation();
        float YawValue = CurrentMeshRot.Yaw + MeshRotateSpeed * DeltaTime;
        FRotator NextRot = FRotator(0, YawValue, 0);
        MeshComp.SetRelativeRotation(NextRot);
    }

    UFUNCTION()
    void SpotLightColor(bool CanBuild)
    {
        if (CanBuild)
            SpotLightComp.LightColor = LightBuildTrue;
        else
            SpotLightComp.LightColor = LightBuildFalse;
    }

    UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        AUZPickUpObject PickUpTarget = Cast<AUZPickUpObject>(OtherActor);
        
        if (PickUpTarget != nullptr)
        {
            if (GameMode != nullptr)
            {
                //rework depending on object type
                switch (PickUpTarget.ObjectType)
                {
                    case PickUpObjectType::Car:
                    GameMode.AddRemoveResources(PickUpTarget.AddAmount);
                    GameMode.CurrentResourcesInLevel--;
                    break;

                    case PickUpObjectType::CitizenPod:
                    GameMode.AddCitizenCount(PickUpTarget.AddAmount);
                    GameMode.CurrentCitizenPods--;
                    break;

                    case PickUpObjectType::Resource:
                    GameMode.AddRemoveResources(PickUpTarget.AddAmount);
                    GameMode.CurrentResourcesInLevel--;
                    break;
                }

            }

            PickUpTarget.DestroyActor();
        }
    }

    UFUNCTION()
    void DisablePlayerControls()
    {

        if (PlayerController != nullptr)
        {
            bIsActive = false;

            if (PullBeam != nullptr)
            {
                PullBeam.IsActive = false;
            }

            if (LaserBeam != nullptr)
            {
                LaserBeam.IsActive = false;
            }
        }
    }
}