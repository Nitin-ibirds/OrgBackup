trigger CompletedAndInprogressCountTrigger on Task (After Insert, After Update, After UnDelete, After delete) {
    CompletedAndInprogressCountClass Obj=new CompletedAndInprogressCountClass();
    Obj.usingQuery();
}