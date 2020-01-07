import GameFiles.UZEvents;
import Statics.UZStaticData; 

class AUZGameMode : AGameModeBase
{


    FGameEndEvent EventEndGame;
    FGameStartEvent EventStartGame;

    ///Place below events into Global Event NAMESPACE
    //Global Event [place in namespace instead]
    FUpdateResources EventUpdateResources;

    //Global Event [place in namespace instead]
    FUpdateLife EventUpdateLife;

    //Global Event [place in namespace instead]
    FUpdateTurretBorder EventUpdateTurretBorder;

    //Global Event [place in namespace instead]
    FUpdateStunTrapBorder EventUpdateStunTrapBorder;

    //Global Event [place in namespace instead]
    FUpdateCitizenCountUI EventUpdateCitizenCountUI;
    
    FTurretExplosionFeedback EventTurretExplosionFeedback;
    FBombTrapExplosionFeedback EventBombTrapExplosionFeedback;
    FEnemyKillFeedback EventEnemyKillFeedback;
    // FPickUpFeedback EventPickUpFeedback;

    //STORE UI REFERENCES FOR DEPARENTING OR ALTERATION
    UUserWidget StartWidgetReference;
    UUserWidget EndWidgetReference;


    //GLOBAL PROPERTIES

    ///Place below values into protection point instead.
    UPROPERTY()
    float Life;

    float MaxLife = 2500.f;

    ///Place below value into Global Event NAMESPACE
    UPROPERTY()
    int Resources = 0;

    //CITIZENS SAVED

    UPROPERTY()
    int CitizenSaveCount = 0;

    UPROPERTY()
    float CitizenUpRate = 0.5f;

    float NewCitizenUpTime;


    //RESOURCE COSTS

    UPROPERTY()
    float TurretCost = 400.f;

    UPROPERTY()
    float StunTrapCost = 100.f;


    //GAME STATE INFO

    bool bGameEnded;

    bool bGameStarted;


    //ENEMY SPAWN TIMES

    UPROPERTY()
    float EnemyMinSpawnTime = 1.9f;

    UPROPERTY()
    float EnemyMaxSpawnTime = 3.9f;

    UPROPERTY()
    float SpawnIncreaseDividerMin = 1.03f;

    UPROPERTY()
    float SpawnIncreaseDividerMax = 1.04f;

    UPROPERTY()
    float IncreaseSpawnTimeRate = 10.f;

    float NewIncreaseSpawnTime;


    //ENEMY SPAWN CHECKS
    int SpawnDifficulty = 0;

    UPROPERTY()
    int Enemy2SpawnDifficulty = 8;

    UPROPERTY()
    int Enemy3SpawnDifficulty = 16;

    UPROPERTY()
    int Enemy4SpawnDifficulty = 25;

    UPROPERTY()
    int Enemy5SpawnDIfficulty = 33;

    bool bCanSpawnEnemy2;

    bool bCanSpawnEnemy3;

    bool bCanSpawnEnemy4;

    bool bCanSpawnEnemy5;


    //ENEMY MOVEMENT SPEED

    UPROPERTY()
    float GlobalMovementSpeedMultiplierMin = 1.015f;

    UPROPERTY()
    float GlobalMovementSpeedMultiplierMax = 1.03f;

    float GlobalMovementSpeed = 115.f;

    UPROPERTY()
    float ZombieNewMoveSpeedRate = 8.f;

    float ZombieNewMoveSpeedTime;


    //PICK UP OBJECTS
    UPROPERTY()
    int MaxResourcesInLevel = 5;

    int CurrentResourcesInLevel;

    UPROPERTY()
    int MaxCitizenPods = 3;

    int CurrentCitizenPods;
    

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        Resources = 1000;
        Life = MaxLife;
        System::SetTimer(this, n"BroadCastWidgetEvents", 0.2f,false);
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        //place life and end game function call from protection point instead (when health values are moved there)
        //check if bGameStarted && !bGameEnded, then call Set Spawn/Citien/Zombie functions
        
        if (Life <= 0 && !bGameEnded)
        {
            EndGame();
        }
        else if (Life > 0 && bGameStarted)
        {
            SetNewSpawnRates();
            SetNewCitizenCount();
            SetNewZombieSpeed();
        }
    }

    ///Place below function into Global Event NAMESPACE
    UFUNCTION()
    void BroadCastWidgetEvents()
    {
        EventUpdateResources.Broadcast();
        EventUpdateLife.Broadcast();
        EventUpdateStunTrapBorder.Broadcast();
        EventUpdateTurretBorder.Broadcast();
        EventUpdateCitizenCountUI.Broadcast(CitizenSaveCount);
    }

    ///Place below function into Global Event NAMESPACE
    UFUNCTION()
    void AddRemoveResources(int InputResources)
    {
        Resources += InputResources;
        EventUpdateResources.Broadcast();
        EventUpdateStunTrapBorder.Broadcast();
        EventUpdateTurretBorder.Broadcast();
    }

    ///Place below function into Global Event NAMESPACE
    UFUNCTION()
    void AddCitizenCount(int Amount)
    {
        CitizenSaveCount += Amount;
    }

    UFUNCTION()
    void StartGame()
    {
        EventStartGame.Broadcast();
        bGameStarted = true;
    }

    UFUNCTION()
    void EndGame()
    {
        EventEndGame.Broadcast();
        //UZGlobalEvents::EventEndGame.Broadcast();
        bGameEnded = true;
    }

    ///Place below function into Global Event NAMESPACE
    UFUNCTION()
    float LifePercent()
    {
        float Percent = Life / MaxLife;
        return Percent;
    }

    UFUNCTION()
    void SetNewSpawnRates()
    {
        if (NewIncreaseSpawnTime <= Gameplay::TimeSeconds)
        {
            NewIncreaseSpawnTime = Gameplay::TimeSeconds + IncreaseSpawnTimeRate;

            float SpawnIncreaseDivider = FMath::RandRange(SpawnIncreaseDividerMin, SpawnIncreaseDividerMax);

            EnemyMinSpawnTime /= SpawnIncreaseDivider;
            EnemyMaxSpawnTime /= SpawnIncreaseDivider;
            SpawnDifficulty++;

            if (SpawnDifficulty >= Enemy2SpawnDifficulty)
            {
                bCanSpawnEnemy2 = true;
            }

            if (SpawnDifficulty >= Enemy3SpawnDifficulty)
            {
                bCanSpawnEnemy3 = true;
            }

            if (SpawnDifficulty >= Enemy4SpawnDifficulty)
            {
                bCanSpawnEnemy4 = true;
            }

            if (SpawnDifficulty >= Enemy5SpawnDIfficulty)
            {
                bCanSpawnEnemy5 = true;
            }
        }
    }

    UFUNCTION()
    void SetNewZombieSpeed()
    {
        if (ZombieNewMoveSpeedTime <= Gameplay::TimeSeconds)
        {
            float GlobalMovementSpeedMultiplier = FMath::RandRange(GlobalMovementSpeedMultiplierMin, GlobalMovementSpeedMultiplierMax);
            GlobalMovementSpeed *= GlobalMovementSpeedMultiplier;
            ZombieNewMoveSpeedTime = Gameplay::TimeSeconds + ZombieNewMoveSpeedRate; 
        }    
    }

    UFUNCTION()
    void SetNewCitizenCount()
    {
        if (NewCitizenUpTime <= Gameplay::TimeSeconds)
        {
            NewCitizenUpTime = Gameplay::TimeSeconds + CitizenUpRate;
            CitizenSaveCount++;
            EventUpdateCitizenCountUI.Broadcast(CitizenSaveCount);
        }
    }
}