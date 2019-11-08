import WorldFiles.UZProtectionPoint;
import GameFiles.UZStaticData;
class AUZObstacle : AActor
{
    //spawn 4 actors at 4 USceneComponent locations

    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UBoxComponent BoxComp;
    default BoxComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Block);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    // UPROPERTY(DefaultComponent, Attach = SceneComp)
    // USceneComponent Corner1;

    // UPROPERTY(DefaultComponent, Attach = SceneComp)
    // USceneComponent Corner2;

    // UPROPERTY(DefaultComponent, Attach = SceneComp)
    // USceneComponent Corner3;

    // UPROPERTY(DefaultComponent, Attach = SceneComp)
    // USceneComponent Corner4;

    // UPROPERTY()
    // TSubclassOf<AActor> ActorClass;
    // AActor ActorRef;

    // UPROPERTY()
    // TArray<USceneComponent> SceneCompArray;

    // UPROPERTY()
    // TArray<AActor> ActorArray;

    // TArray<AUZProtectionPoint> ProtectionPointArray;

    // AUZProtectionPoint ProtectionPointRef;

    // int IndexSize;

    // UPROPERTY()
    // TArray<AActor> PriorityLocationArray;

    // //used to ensure that the correct locations are being added in the right order
    // UPROPERTY()
    // TArray<float> PriorityDistanceArray; 

    // UFUNCTION(BlueprintOverride)
    // void BeginPlay()
    // {
    //     // AUZProtectionPoint::GetAll(ProtectionPointArray);
    //     // ProtectionPointRef = ProtectionPointArray[0];
    //     // BuildPriorityArray();
    //     // Tags.Add(UZTags::IsTracableByPlayer);
    // }

    // UFUNCTION()
    // void BuildPriorityArray()
    // {
    //     if (ProtectionPointRef == nullptr)
    //     return; 
        
    //     SceneCompArray.Add(Corner1);
    //     SceneCompArray.Add(Corner2);
    //     SceneCompArray.Add(Corner3);
    //     SceneCompArray.Add(Corner4);

    //     for (int a = 0; a < SceneCompArray.Num(); a++)
    //     {
    //         ActorRef = SpawnActor(ActorClass, SceneCompArray[a].GetWorldLocation());
    //         ActorArray.Add(ActorRef);
    //     }

    //     IndexSize = ActorArray.Num();

    //     for(int i = 0; i < IndexSize; i++)
    //     {
    //         float DistanceChecker = 500400.f;
    //         int ActorArrayIndex = 0;
            
    //         for (int c = 0; c < ActorArray.Num(); c++)
    //         {
    //             if (DistanceToProtectionPoint(ProtectionPointRef, ActorArray[c]) < DistanceChecker)
    //             {
    //                 DistanceChecker = DistanceToProtectionPoint(ProtectionPointRef, ActorArray[c]);
    //                 ActorArrayIndex = c;
    //             }
    //         }
            
    //         // FVector NextLocation = ActorArray[ActorArrayIndex].ActorLocation;
    //         PriorityLocationArray.Add(ActorArray[ActorArrayIndex]);
    //         PriorityDistanceArray.Add(DistanceToProtectionPoint(ProtectionPointRef, ActorArray[ActorArrayIndex]));     
    //         ActorArray.RemoveAt(ActorArrayIndex);  
    //     }

  
    // }

    // UFUNCTION()
    // float DistanceToProtectionPoint(AUZProtectionPoint ProtectionPoint, AActor Point)
    // {
    //     float Distance = 0.f;

    //     Distance = (ProtectionPoint.ActorLocation - Point.ActorLocation).Size();   

    //     return Distance;
    // }

    //check in order which is closest and furtherest from the protection point



}