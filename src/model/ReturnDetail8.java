package model;

public class ReturnDetail8 {
    private int returnDetailId;
    private String copyCondition;
    private FineRecord8 fineRecord;

    public ReturnDetail8() {
    }

    public ReturnDetail8(int returnDetailId, String copyCondition, FineRecord8 fineRecord) {
        this.returnDetailId = returnDetailId;
        this.copyCondition = copyCondition;
        this.fineRecord = fineRecord;
    }

    public int getReturnDetailId() {
        return returnDetailId;
    }

    public void setReturnDetailId(int returnDetailId) {
        this.returnDetailId = returnDetailId;
    }

    public String getCopyCondition() {
        return copyCondition;
    }

    public void setCopyCondition(String copyCondition) {
        this.copyCondition = copyCondition;
    }

    public FineRecord8 getFineRecord() {
        return fineRecord;
    }

    public void setFineRecord(FineRecord8 fineRecord) {
        this.fineRecord = fineRecord;
    }
}
