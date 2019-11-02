import PlayerFiles.UZCameraActor;
import PlayerFiles.UZLaserBeam;
import PlayerFiles.UZPullBeam;
import GameFiles.UZGameMode;
import WorldFiles.UZResource;
import WorldFiles.UZRemoteCannon;

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
    USceneComponent TurretSpawnOrigin;

    UPROPERTY(DefaultComponent)
    UFloatingPawnMovement FloatingPawnComp;

    AUZGameMode GameMode;
    APlayerController PlayerController;

    UPROPERTY()
    TSubclassOf<AActor> LaserBeamClass;
    AActor LaserBeamRef;
    AUZLaserBeam LaserBeam;

    UPROPERTY()
    TSubclassOf<AActor> PullBeamClass;
    AActor PullBeamRef;
    AUZPullBeam PullBeam;

    UPROPERTY()
    float MovementSpeed;

    UPROPERTY(DefaultComponent)
    UInputComponent InputComp;

    UPROPERTY()
    TArray<AUZCameraActor> CameraArray;
    AUZCameraActor CameraObj;

    UPROPERTY()
    TSubclassOf<AActor> RemoteCannonClass;
    AActor RemoteCannonRef;

    UPROPERTY()
    float SpawnObjTime;
    float NewTime; 

    bool bIsActive = true;
    bool bLaserOn;
    bool bPullOn;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        SphereCompResourceCatch.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode()); 

        PlayerGameModeSetUp();
        PlayerCamSetup();
        PlayerInputSetup();
    }

    UFUNCTION()
    void PlayerGameModeSetUp()
    {
        if (GameMode != nullptr)
        {
            GameMode.EventEndGame.AddUFunction(this, n"DisablePlayerControls");
        }
    }

    UFUNCTION()
    void PlayerCamSetup()
    {
        AUZCameraActor::GetAll(CameraArray);
        PlayerController = Gameplay::GetPlayerController(0);
        if (PlayerController != nullptr)
        {
            PlayerController.SetViewTargetWithBlend(CameraArray[0], 0.f);
            CameraObj = CameraArray[0];
            if (CameraObj != nullptr)
            {
                CameraObj.GetPlayerReference(this); 
            }
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
    }

    UFUNCTION()
    void StartPressed(FKey Key)
    {

        if (GameMode != nullptr && GameMode.bGameEnded)
        {
            Print("Start pressed", 5.f);
            Gameplay::OpenLevel(n"MainMap");
        }
        else if (GameMode != nullptr && GameMode.bGameNotStarted)
        {
            Print("Start pressed", 5.f);
            GameMode.StartGame();
        }
    }

    UFUNCTION()
    void MovePForward(float AxisValue)
    {
        if (bIsActive)
        {
            AddMovementInput(ControlRotation.ForwardVector, AxisValue);
        }
    }

    UFUNCTION()
    void MovePRight(float AxisValue)
    {
        if (bIsActive)
        {
            AddMovementInput(ControlRotation.RightVector, AxisValue);         
        }
    }

    UFUNCTION()
    void LaserCannonOn(FKey Key)
    {
        if (bIsActive && !bPullOn)
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
        if (LaserBeam != nullptr && bIsActive)
        {
            LaserBeam.IsActive = false;
            bLaserOn = false;
        }
    }

    UFUNCTION()
    void PullBeamOn(FKey Key)
    {
        if (bIsActive && !bLaserOn)
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
        if (PullBeam != nullptr && bIsActive)
        {
            PullBeam.IsActive = false;
            bPullOn = false;
        }
    }

    UFUNCTION()
    void SpawnTurret(FKey Key)
    {
        RemoteCannonRef = SpawnActor(RemoteCannonClass, TurretSpawnOrigin.GetWorldLocation());
    }

    UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        AUZResource Resource = Cast<AUZResource>(OtherActor);
        
        if (Resource != nullptr)
        {
            if (GameMode != nullptr)
            {
                GameMode.AddRemoveResources(Resource.ResourceAmount);
            }
            Resource.DestroyActor();
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