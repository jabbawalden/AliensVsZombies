import Components.UZObjectRotation;
import PlayerFiles.UZPlayerMain;

class AUZRemoteCannon : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxComp;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USphereComponent SphereComp;
    default SphereComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);
    default SphereComp.SetCollisionResponseToChannel(ECollisionChannel::ECC_Visibility, ECollisionResponse::ECR_Ignore);
    default SphereComp.SetCollisionResponseToChannel(ECollisionChannel::ECC_Camera, ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent)
    UUZObjectRotation ObjectRotationComp;

    UPROPERTY()
    TSubclassOf<AActor> ProjectileClass;
    AActor ProjectileReference;

    UPROPERTY()
    AActor TargetActor;
    
    // TArray<AUZPlayerMain> PlayerTarget;

    UPROPERTY()
    TArray<AActor> EnemyArray;

    UPROPERTY()
    FRotator LookAtRotation;

    float InterpSpeed = 2.5f;

    int ShootTargetIndex;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        // AUZPlayerMain::GetAll(PlayerTarget);
        // TargetActor = PlayerTarget[0];
        SphereComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
        SphereComp.OnComponentEndOverlap.AddUFunction(this, n"TriggerOnEndOverlap");

    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        float ClosestDistance = 15000.f;

        for(int i = 0; i < EnemyArray.Num(); i++)
        {
            float DistanceTo = GetDistanceTo(EnemyArray[i]);

            if(DistanceTo < ClosestDistance)
            {
                ClosestDistance = DistanceTo;
                // ShootTargetIndex = i;
                // Print("" + ShootTargetIndex, 0.f);
                TargetActor = EnemyArray[i];
            }
        }

        if (TargetActor != nullptr)
        {
            ObjectRotationComp.SetOwnerRotation(DeltaSeconds, TargetActor.ActorLocation); 
        }
        else
        {
            ObjectRotationComp.SetOwnerRotation(DeltaSeconds, FVector(0)); 
        }

    }

    UFUNCTION()
    void FireProjectile()
    {

    }

    UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        if (OtherActor.Tags.Contains(n"Enemy"))
        {
            Print("Enemy Detected", 5.f);
            EnemyArray.Add(OtherActor);
        }
    }

        UFUNCTION()
    void TriggerOnEndOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex) 
    {
        if (OtherActor.Tags.Contains(n"Enemy"))
        {
            Print("Enemy Destroyed", 5.f);
            EnemyArray.Remove(OtherActor);
        }
    }
}