import Widgets.UZPopUpWidget;

class AUZPopUpUI : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UWidgetComponent UserWidget;

    UUZPopUpWidget PopUpWidget;

    FString TextInput;

    UPROPERTY()
    float MovementSpeed = 550.f;

    UPROPERTY()
    float DestructionTime = 0.5f;

    UPROPERTY()
    float MoveUpTime = 1.f;

    bool bMoveUp = true;
    bool bTimerSet;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        PopUpWidget = Cast<UUZPopUpWidget>(UserWidget.GetUserWidgetObject());

        if (PopUpWidget == nullptr)
        return;

        System::SetTimer(this, n"MoveUpFalse", MoveUpTime, false);
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
    void MoveUpFalse()
    {
        bMoveUp = false;
    }

    UFUNCTION()
    void DestroyUI()
    {
        DestroyActor();
    }

    UFUNCTION()
    void SetWidgetText()
    {
        PopUpWidget.UpdatePopUpText(TextInput); 
    }

}