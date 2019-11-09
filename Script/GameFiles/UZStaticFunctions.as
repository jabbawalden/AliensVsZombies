import GameFiles.UZStartGameWidget;
import GameFiles.UZGameMode;


UFUNCTION(Category = "Player HUD")
void AddStartWidgetToHUD(APlayerController PlayerController, TSubclassOf<UUserWidget> WidgetClass)
{
    UUserWidget WidgetGetRef = WidgetBlueprint::CreateWidget(WidgetClass, PlayerController);

    AUZGameMode GameMode = Cast<AUZGameMode>(Gameplay::GetGameMode());
    if (GameMode == nullptr)
    return;

    GameMode.StartWidgetReference = WidgetGetRef; 

    WidgetGetRef.AddToViewport();
}

UFUNCTION(Category = "Player HUD")
void RemoveStartWidgetFromHUD(APlayerController PlayerController, UUZStartGameWidget Widget)
{
    Widget.RemoveFromParent();
}

UFUNCTION(Category = "Player HUD")
void AddMainWidgetToHUD(APlayerController PlayerController, TSubclassOf<UUserWidget> WidgetClass)
{
    UUserWidget UserWidget = WidgetBlueprint::CreateWidget(WidgetClass, PlayerController);
    UserWidget.AddToViewport();
}

//Used to randomize map layout.
//Not an ideal way - inital thinking was to generate map procedurally and then build navmesh dynamically. Had trouble making this work and needed to prioritize tasks
//Dynamic setting on Navmesh was too performance costly when objects were spawned
//The benefit of this method is that map design can be more thought out
FName UZMaps(int Index)
{
    FName MapOutput;

    switch (Index)
    {
        case 1:
        MapOutput = n"MainMap1";
        break;
        
        case 2:
        MapOutput = n"MainMap2";
        break;
        
        case 3:
        MapOutput = n"MainMap3";
        break;
        
        case 4:  
        MapOutput = n"MainMap4";    
        break;

        case 5:
        MapOutput = n"MainMap5";
        break;
        
        case 6:  
        MapOutput = n"MainMap6";    
        break;
    }

    return MapOutput; 
}
