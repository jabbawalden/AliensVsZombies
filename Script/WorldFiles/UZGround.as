import GameFiles.UZStaticData;

class AUZGround : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Block);

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        Tags.Add(UZTags::IsTracableByPlayer);
    }
}