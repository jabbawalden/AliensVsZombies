import Components.UZHealthComp;
import Statics.UZStaticData;

class AUZBombExplosion : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USphereComponent SphereComp;
    default SphereComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);

    // UPROPERTY()
    // TSubclassOf<AActor> ParticleFX;
    // AActor ParticleFXRef;

    UPROPERTY()
    float Damage = 100.f;

    UPROPERTY()
    float DestructionTime = 0.3f;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        SphereComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlapSphere");
        // ParticleFXRef = SpawnActor(ParticleFX, ActorLocation); 
        BPEventSpawnParticle();

        System::SetTimer(this, n"DestroyExplosion", DestructionTime, false);
    }

    UFUNCTION()
    void DestroyExplosion()
    {
        Print("Destroy explosion bomb", 5.f);
        DestroyActor();
    }

    UFUNCTION(BlueprintEvent)
    void BPEventSpawnParticle()
    {

    }

    UFUNCTION()
    void TriggerOnBeginOverlapSphere(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        if (OtherActor.Tags.Contains(UZTags::Enemy))
        {
            UUZHealthComp HealthComp = UUZHealthComp::Get(OtherActor);

            if (HealthComp == nullptr)
            return;

            HealthComp.DamageHealth(Damage);
        }
    }

}