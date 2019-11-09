import WorldFiles.UZPickUpObject;
import Components.UZHealthComp;
import Statics.UZStaticData;

class AUZPullBeam : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UBoxComponent BoxComp;
    default BoxComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY()
    float HealAmount = 8.f;
    UPROPERTY()
    float HealRate = 0.25f;
    float NewHealTime;

    TArray<UUZHealthComp> HealthCompArray;

    AActor PlayerRef;

    bool IsActive = true;


    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        BoxComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
        BoxComp.OnComponentEndOverlap.AddUFunction(this, n"TriggerOnEndOverlap");
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {

        // HealTurrets();

        if (!IsActive)
        {
            DestroyActor();
        }
    }

    UFUNCTION()
    void SetFollowTarget(AActor TargetActor)
    {
        AttachToActor(TargetActor);
    }

    // UFUNCTION()
    // void HealTurrets()
    // {
    //     if (HealthCompArray.Num() == 0)
    //     return;

    //     if (NewHealTime < Gameplay::TimeSeconds)
    //     {
    //         NewHealTime = Gameplay::TimeSeconds + HealRate;
    //         for (int i = 0; i < HealthCompArray.Num(); i++)
    //         {
    //             HealthCompArray[i].Heal(HealAmount); 
    //         }
    //     }
    // }

    UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        if (OtherActor.Tags.Contains(UZTags::PickUp))
        {
            AUZPickUpObject PickUpTarget = Cast<AUZPickUpObject>(OtherActor);

            if (PickUpTarget == nullptr)
            return;
            
            PickUpTarget.SetTargetReference(this);
            PickUpTarget.IsCollecting = true;
            PickUpTarget.SetPhysicsSimulation(false);
            
        }

        //healing turets - testing new mechanic

        // if (OtherActor.Tags.Contains(UZTags::Turret))
        // {
        //     UUZHealthComp HealthComp = UUZHealthComp::Get(OtherActor);

        //     if (HealthComp == nullptr)
        //     return;

        //     HealthCompArray.Add(HealthComp);
        //     Print("Added Turret", 5.f);
        // }
    }

    UFUNCTION()
    void TriggerOnEndOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex) 
    {
        if (OtherActor.Tags.Contains(UZTags::PickUp))
        {
            AUZPickUpObject PickUpTarget = Cast<AUZPickUpObject>(OtherActor);

            if (PickUpTarget != nullptr)
            {
                PickUpTarget.IsCollecting = false;
                PickUpTarget.SetPhysicsSimulation(true);
            }
        }

        //healing turets - testing new mechanic

        // if (OtherActor.Tags.Contains(UZTags::Turret))
        // {
        //     UUZHealthComp HealthComp = UUZHealthComp::Get(OtherActor);

        //     if (HealthComp == nullptr)
        //     return;

        //     HealthCompArray.Remove(HealthComp);
        //     Print("Removed Turret", 5.f);
        // }
    }
}