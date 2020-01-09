import PlayerFiles.UZCameraActor;
import PlayerFiles.UZLaserBeam;
import PlayerFiles.UZPullBeam;
import GameFiles.UZGameMode;
import WorldFiles.UZPickUpObject;
import PlayerFiles.UZRemoteCannon;
import Widgets.UZPlayerWidget;
import Statics.UZStaticFunctions;
import GameFiles.UZMainMenuManager;
import Widgets.UZEndGameWidget;
import Widgets.UZPopUpUI;
import Statics.UZStaticData;
import GameFiles.UZEvents; 
import Components.UZPlayerSoundComp;

class AUZPlayerMain : APawn
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USceneComponent MeshHolder;

    UPROPERTY(DefaultComponent, Attach = MeshHolder)
    UStaticMeshComponent MeshComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USpotLightComponent SpotLightComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USphereComponent SphereCompCatchPickUps;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USceneComponent SpawnObjectOrigin;

    UPROPERTY(DefaultComponent)
    UFloatingPawnMovement FloatingPawnComp;
    default FloatingPawnComp.MaxSpeed = 1550.f;

    UPROPERTY(DefaultComponent)
    UInputComponent InputComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UAudioComponent LaserBeamSound;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UAudioComponent PullBeamSound;

    UPROPERTY(DefaultComponent)
    UUZPlayerSoundComp PlayerSoundComp;

    UPROPERTY(DefaultComponent)
    UUZTraceCheckComp TraceCheckComp;

    UPROPERTY()
    UForceFeedbackEffect TurrentExplosionFeedback;

    UPROPERTY()
    UForceFeedbackEffect BombTrapExplosionFeedback;

    UPROPERTY()
    UForceFeedbackEffect EnemyKillFeedback;

    UPROPERTY()
    UForceFeedbackEffect PickUpFeedback;
    
    UPROPERTY()
    UForceFeedbackEffect BuildFeedback;

    UPROPERTY()
    float TestFloat;

    UPROPERTY()
    TSubclassOf<AActor> LaserBeamClass;
    AActor LaserBeamRef;
    AUZLaserBeam LaserBeam;

    UPROPERTY()
    TSubclassOf<AActor> PullBeamClass;
    AActor PullBeamRef;
    AUZPullBeam PullBeam;

    UPROPERTY()
    TSubclassOf<AActor> BombTrap;
    AActor BombTrapRef;

    UPROPERTY()
    TArray<AUZCameraActor> CameraArray;
    AUZCameraActor CameraObj;

    UPROPERTY()
    TSubclassOf<AActor> RemoteCannonClass;
    AActor RemoteCannonRef;

    UPROPERTY()
    TSubclassOf<AActor> PopUpUI;
    AActor PopUpUIRef;

    AUZPopUpUI PopUpUIClass;

    UPROPERTY()
    TSubclassOf<UUserWidget> MainWidget;

    UPROPERTY()
    TSubclassOf<UUserWidget> StartWidget;

    //TODO Implement this
    UPROPERTY()
    TSubclassOf<UUserWidget> EndWidget;

    UUZEndgameWidget EndWidgetRef;

    UPROPERTY()
    FLinearColor LightBuildTrue;

    UPROPERTY()
    FLinearColor LightBuildFalse;

    UPROPERTY()
    USoundCue SpawnTurretSound;

    AUZGameMode GameMode;

    APlayerController PlayerController;

    UPROPERTY()
    TArray<AUZMainMenuManager> MainMenuArray;

    AUZMainMenuManager MainMenu;

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
    float XLocAllowedMovement = 3400.f;
    UPROPERTY()
    float YLocAllowedMovement = 3300.f;

    UPROPERTY()
    float MeshRotateSpeed = 100.f;

    float PitchRot;
    float RollRot;
    float RotDegreeMultiplier = 15.f;
    float RotInterpSpeed = 4.f;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        SphereCompCatchPickUps.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode()); 

        if (GameMode == nullptr)
        return;

        GameMode.EventTurretExplosionFeedback.AddUFunction(this, n"ControllerTurretExplosionFeedback");
        GameMode.EventBombTrapExplosionFeedback.AddUFunction(this, n"ControllerBombTrapExplosionFeedback");
        GameMode.EventEnemyKillFeedback.AddUFunction(this, n"ControllerEnemyKillFeedback");
        // GameMode.EventPickUpFeedback.AddUFunction(this, n"ControllerPickUpFeedback");

        PlayerController = Gameplay::GetPlayerController(0);

        if (PlayerController == nullptr)
        return;

        PlayerGameModeSetUp();
        PlayerCamSetup();
        PlayerInputSetup();

        AUZMainMenuManager::GetAll(MainMenuArray);

        if (MainMenuArray.Num() > 0)
        {
            MainMenu = MainMenuArray[0];
        }

        if (MainMenu != nullptr)
        return;

        AddWidgetToHUD(PlayerController, MainWidget);
        AddStartWidgetToHUD(PlayerController, StartWidget);

        LaserBeamSound.Play();
        PullBeamSound.Play();
        LaserBeamSound.VolumeMultiplier = PlayerSoundComp.MinVol;
        PullBeamSound.VolumeMultiplier = PlayerSoundComp.MinVol;
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        SetMeshRotation(DeltaSeconds);
        SpotLightColor(TraceCheckComp.bIsInRangeOfTarget);
        InputRotationMovement(DeltaSeconds);
        LaserPullBeamsVolumeUpdate(DeltaSeconds); 
    }

    UFUNCTION()
    void PlayerGameModeSetUp()
    {
        GameMode.EventEndGame.AddUFunction(this, n"EndGame");
        //UZGlobalEvents::EventEndGame.AddUFunction(this, n"EndGame");
        GameMode.EventStartGame.AddUFunction(this, n"StartGame");
    }

    UFUNCTION()
    void PlayerCamSetup()
    {
        if (PlayerController == nullptr)
        return;

        AUZCameraActor::GetAll(CameraArray);

        if (CameraArray.Num() > 0)
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
        InputComp.BindAction(n"BuildStunTrap", EInputEvent::IE_Pressed, FInputActionHandlerDynamicSignature(this, n"SpawnBombTrap")); 
    }

    UFUNCTION()
    void InputRotationMovement(float DeltaSeconds)
    {
        float InterPitch = FMath::FInterpTo(MeshHolder.GetRelativeRotation().Pitch, -PitchRot, DeltaSeconds, RotInterpSpeed);
        float InterpRoll = FMath::FInterpTo(MeshHolder.GetRelativeRotation().Roll, RollRot, DeltaSeconds, RotInterpSpeed);
        FRotator NewMeshRot = FRotator(InterPitch, 0, InterpRoll);
        MeshHolder.SetRelativeRotation(NewMeshRot);
    }

    UFUNCTION()
    void StartPressed(FKey Key)
    {
        if (GameMode == nullptr)
        return;

        int R = FMath::RandRange(1,6);

        if (MainMenu != nullptr)
        {
            Gameplay::OpenLevel(UZMaps(R));
        }
        else if (GameMode.bGameEnded)
        {
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
        if (MainMenu != nullptr)
        return;

        if (!bIsActive)
        return;
        
        if (ActorLocation.X > -XLocAllowedMovement && AxisValue < 0)
            AddMovementInput(ControlRotation.ForwardVector, AxisValue);
        else if (ActorLocation.X < XLocAllowedMovement && AxisValue > 0)  
            AddMovementInput(ControlRotation.ForwardVector, AxisValue);

        PitchRot = AxisValue * RotDegreeMultiplier;
    }

    UFUNCTION()
    void MovePRight(float AxisValue)
    {
        if (MainMenu != nullptr)
        return;

        if (!bIsActive)
        return;

        if (ActorLocation.Y > -YLocAllowedMovement && AxisValue < 0)
            AddMovementInput(ControlRotation.RightVector, AxisValue); 
        else if (ActorLocation.Y < YLocAllowedMovement && AxisValue > 0)  
            AddMovementInput(ControlRotation.RightVector, AxisValue);    

        RollRot = AxisValue * RotDegreeMultiplier;   
    }

    UFUNCTION()
    void LaserCannonOn(FKey Key)
    {
        if (MainMenu != nullptr)
        return;

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
                PlayerSoundComp.LaserBeamMode(true);
                GameMode.EventStartLaserBeam.Broadcast();
            }
        }
    }

    UFUNCTION()
    void LaserCannonOff(FKey Key)
    {
        if (MainMenu != nullptr)
        return;

        if (!bIsActive)
        return;

        if (LaserBeam != nullptr)
        {
            LaserBeam.DestroyActor();
            bLaserOn = false;
            PlayerSoundComp.LaserBeamMode(false);
        }
    }

    UFUNCTION()
    void PullBeamOn(FKey Key)
    {
        if (MainMenu != nullptr)
        return;

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
                PlayerSoundComp.PullBeamMode(true);
            }
        }
    }

    UFUNCTION()
    void PullBeamOff(FKey Key)
    {
        if (MainMenu != nullptr)
        return;

        if (!bIsActive)
        return;

        if (PullBeam == nullptr)
        return;

        PullBeamRef.DestroyActor();
        bPullOn = false;
        PlayerSoundComp.PullBeamMode(false);
    }

    UFUNCTION()
    void LaserPullBeamsVolumeUpdate(float DeltaTime)
    {
        if (PlayerSoundComp.bLaserBeamPlay)
            LaserBeamSound.VolumeMultiplier = FMath::FInterpTo(LaserBeamSound.VolumeMultiplier, PlayerSoundComp.MaxVol, DeltaTime, PlayerSoundComp.FadeInterpSpeed);
        else
            LaserBeamSound.VolumeMultiplier = FMath::FInterpTo(LaserBeamSound.VolumeMultiplier, PlayerSoundComp.MinVol, DeltaTime, PlayerSoundComp.FadeInterpSpeed);  

        if (PlayerSoundComp.bPullBeamPlay)
            PullBeamSound.VolumeMultiplier = FMath::FInterpTo(PullBeamSound.VolumeMultiplier, PlayerSoundComp.MaxVol, DeltaTime, PlayerSoundComp.FadeInterpSpeed);
        else
            PullBeamSound.VolumeMultiplier = FMath::FInterpTo(PullBeamSound.VolumeMultiplier, PlayerSoundComp.MinVol, DeltaTime, PlayerSoundComp.FadeInterpSpeed);     
    }

    UFUNCTION()
    void SpawnTurret(FKey Key)
    {
        if (MainMenu != nullptr)
        return;

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
                Gameplay::PlaySound2D(SpawnTurretSound, 1.f, 1.f, 0.f); 
                ControllerBuildFeedback();
            }    
        }
        //TEST CONTROLLER RUMBLE
    }

    UFUNCTION()
    void SpawnBombTrap(FKey Key)
    {
        if (MainMenu != nullptr)
        return;

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
                BombTrapRef = SpawnActor(BombTrap, SpawnObjectOrigin.GetWorldLocation());
                GameMode.AddRemoveResources(-GameMode.StunTrapCost); 
                ControllerBuildFeedback();
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
    void StartGame()
    {
        bIsActive = true;

        if (GameMode.StartWidgetReference == nullptr)
        return;

        GameMode.StartWidgetReference.RemoveFromParent(); 
    }
    
    UFUNCTION()
    void EndGame()
    {
        AddEndWidgetToHUD(PlayerController, EndWidget);

        if (GameMode.EndWidgetReference == nullptr)
        return;

        EndWidgetRef = Cast<UUZEndgameWidget>(GameMode.EndWidgetReference);

        if (EndWidgetRef != nullptr)
            EndWidgetRef.SetCitizensDisplayText(); 


        if (PlayerController != nullptr)
        {
            bIsActive = false;

            if (PullBeam != nullptr)
            {
                PullBeam.DestroyActor();
            }

            if (LaserBeam != nullptr)
            {
                LaserBeam.DestroyActor();
            }
        }
    }

    UFUNCTION()
    void SpawnPickUpObjUI(PickUpObjectType ObjectType, int Amount)
    {
        PopUpUIRef = SpawnActor(PopUpUI, ActorLocation);
        PopUpUIRef.AttachToActor(this);

        PopUpUIClass = Cast<AUZPopUpUI>(PopUpUIRef);

        if (PopUpUIClass == nullptr)
        return;

        switch (ObjectType)
        {
            case PickUpObjectType::CitizenPod:
            PopUpUIClass.TextInput = "+" + Amount + " CITIZENS";
            PopUpUIClass.SetWidgetText();
            break;

            case PickUpObjectType::Resource:
            PopUpUIClass.TextInput = "" + Amount + " RESOURCES";
            PopUpUIClass.SetWidgetText();          
            break;
        }
    }

    UFUNCTION()
    void ControllerTurretExplosionFeedback()
    {
        PlayerController.ClientPlayForceFeedback(TurrentExplosionFeedback, NAME_None, false, true, false);
    }

    UFUNCTION()
    void ControllerBombTrapExplosionFeedback()
    {
        PlayerController.ClientPlayForceFeedback(BombTrapExplosionFeedback, NAME_None, false, true, false);
    }

    UFUNCTION()
    void ControllerEnemyKillFeedback()
    {
        PlayerController.ClientPlayForceFeedback(EnemyKillFeedback, NAME_None, false, true, false);
    }

    UFUNCTION()
    void ControllerPickUpFeedback()
    {
        PlayerController.ClientPlayForceFeedback(PickUpFeedback, NAME_None, false, true, false);
    }

    UFUNCTION()
    void ControllerBuildFeedback()
    {
        PlayerController.ClientPlayForceFeedback(BuildFeedback, NAME_None, false, true, false);
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
                    case PickUpObjectType::CitizenPod:
                    GameMode.AddCitizenCount(PickUpTarget.AddAmount);
                    GameMode.CurrentCitizenPods--;
                    GameMode.EventCitizenPickUpFeedback.Broadcast();
                    PlayerSoundComp.PlayCitizenPickUpSound();
                    break;

                    case PickUpObjectType::Resource:
                    GameMode.AddRemoveResources(PickUpTarget.AddAmount);
                    GameMode.CurrentResourcesInLevel--;
                    GameMode.EventResourcePickUpFeedback.Broadcast();
                    PlayerSoundComp.PlayResourcePickUp();
                    break;
                }

                SpawnPickUpObjUI(PickUpTarget.ObjectType, PickUpTarget.AddAmount);
                ControllerPickUpFeedback(); 
            }

            PickUpTarget.DestroyActor();
        }
    }

}