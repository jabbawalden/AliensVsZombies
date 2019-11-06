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