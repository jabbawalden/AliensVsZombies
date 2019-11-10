import GameFiles.UZPopUpWidget;

class AUZPopUpUI : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UWidgetComponent UserWidget;

    UUZPopUpWidget PopUpWidget;

    UPROPERTY()
    float MovementSpeed = 110.f;

    UPROPERTY()
    float DestructionTime = 0.8f;

    bool bMoveUp = true;
    bool bTimerSet;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (bMoveUp)
        {
            FVector NextLoc = ActorLocation + FVector(0,0,MovementSpeed * DeltaSeconds);
            SetActorLocation(NextLoc);
        }
        else if (!bMoveUp && !bTimerSet)
        {
            System::SetTimer(this, n"DestroyUI", DestructionTime, false);
            bTimerSet = true;
        }
    }

    UFUNCTION()
    void DestroyUI()
    {
        DestroyActor();
    }

}