import Statics.UZStaticData;

class AUZGround : AActor
{
    UPROPERTY(DefaultComponent, DefaultComponent)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Block);
    default MeshComp.SetCollisionObjectType(ECollisionChannel::ECC_WorldStatic);

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        Tags.Add(UZTags::IsTracableByPlayer);
    }
}