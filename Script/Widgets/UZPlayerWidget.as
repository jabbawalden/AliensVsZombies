import GameFiles.UZGameMode;

class UUZPlayerMainWidget : UUserWidget
{
    AUZGameMode GameMode;
    
    UPROPERTY()
    FLinearColor CanBuilColor;
    
    UPROPERTY()
    FLinearColor NoBuildColor;

    bool bTurretAnimNotify;

    bool bBombAnimNotify;

    UFUNCTION(BlueprintOverride)
    void Construct()
    {
        GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode());

        if (GameMode != nullptr)
        {
            GameMode.EventUpdateLife.AddUFunction(this, n"UpdateLifeBar");
            GameMode.EventUpdateResources.AddUFunction(this, n"UpdateResourcesText");
            GameMode.EventUpdateTurretBorder.AddUFunction(this, n"UpdateCanBuildTurret");
            GameMode.EventUpdateStunTrapBorder.AddUFunction(this, n"UpdateCanBuildBombTrap");
            GameMode.EventUpdateCitizenCountUI.AddUFunction(this, n"UpdateCitizenCount");
            GameMode.EventResourcePickUpFeedback.AddUFunction(this, n"ResourcesAnim");
        } 
    }

    UFUNCTION(BlueprintEvent)
    UTextBlock GetResourceWidgetText()
    {
        throw("You must use override GetResourceWidgetText from the widget blueprint to return the correct text widget.");
        return nullptr;
    }

    UFUNCTION(BlueprintEvent)
    UTextBlock GetCitizenCountText()
    {
        throw("You must use override GetResourceWidgetText from the widget blueprint to return the correct text widget.");
        return nullptr;
    }

    UFUNCTION(BlueprintEvent)
    UProgressBar GetHealthProgressBar()
    {
        throw("You must use override GetHealthProgressBar from the widget blueprint to return the correct text widget.");
        return nullptr;
    }

    UFUNCTION(BlueprintEvent)
    UBorder GetBorderTurret()
    {
        throw("You must use override GetBorderTurret from the widget blueprint to return the correct text widget.");
        return nullptr;
    }
    
    UFUNCTION(BlueprintEvent)
    UBorder GetBorderStunTrap()
    {
        throw("You must use override GetBorderStunTrap from the widget blueprint to return the correct text widget.");
        return nullptr;
    }

    UFUNCTION(BlueprintEvent)
    UTextBlock GetTurretCost()
    {
        throw("You must use override GetTurretCost from the widget blueprint to return the correct text widget.");
        return nullptr;
    }

    UFUNCTION(BlueprintEvent)
    UTextBlock GetBombCost()
    {
        throw("You must use override GetBombCost from the widget blueprint to return the correct text widget.");
        return nullptr;
    }

    UFUNCTION()
    void UpdateCanBuildTurret()
    {
        //if resources is above turret cost
        if (GameMode.Resources >= GameMode.TurretCost)
        {
            UBorder OurBorder = GetBorderTurret();
            OurBorder.SetBrushColor(CanBuilColor);
            if (bTurretAnimNotify)
            {
                bTurretAnimNotify = false;
                TurretAnim();              
            }
        }
        else
        {
            UBorder OurBorder = GetBorderTurret();
            OurBorder.SetBrushColor(NoBuildColor);
            bTurretAnimNotify = true;
        }
        //else set border color
    }

    UFUNCTION(BlueprintEvent)
    void TurretAnim()
    {

    }


    UFUNCTION()
    void UpdateCanBuildBombTrap()
    {
        if (GameMode.Resources >= GameMode.StunTrapCost)
        {
            UBorder OurBorder = GetBorderStunTrap();
            OurBorder.SetBrushColor(CanBuilColor);
            if (bBombAnimNotify)
            {
                bBombAnimNotify = false;
                BombAnim();
            }
        }
        else
        {
            UBorder OurBorder = GetBorderStunTrap();
            OurBorder.SetBrushColor(NoBuildColor);
            bBombAnimNotify = true;
        }
    }

    UFUNCTION(BlueprintEvent)
    void BombAnim()
    {
        
    }

    UFUNCTION()
    void UpdateResourcesText()
    {
        UTextBlock ResourceDisplay = GetResourceWidgetText();
        ResourceDisplay.Text = FText::FromString("" + GameMode.Resources); 
    }

    UFUNCTION(BlueprintEvent)
    void ResourcesAnim()
    {
        
    }

    UFUNCTION()
    void UpdateLifeBar()
    {
        UProgressBar ProgressBar = GetHealthProgressBar();
        ProgressBar.Percent = GameMode.LifePercent();
    }

    UFUNCTION()
    void UpdateCitizenCount(int CitizenCount)
    {
        UTextBlock CitizenDisplay = GetCitizenCountText();
        CitizenDisplay.Text = FText::FromString("Citizen Count: " + CitizenCount);
    }

}

