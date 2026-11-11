package model;

public class DocumentTypeCopy8 {
    private int copyId;
    private String status;
    private String copyCondition;
    private LoanDetail8[] loanDetails;
    private ReturnDetail8[] returnDetails;
    private ImportDetail8[] importDetails;

    public DocumentTypeCopy8() {
    }

    public DocumentTypeCopy8(int copyId, String status, String copyCondition,
                            LoanDetail8[] loanDetails, ReturnDetail8[] returnDetails,
                            ImportDetail8[] importDetails) {
        this.copyId = copyId;
        this.status = status;
        this.copyCondition = copyCondition;
        this.loanDetails = loanDetails;
        this.returnDetails = returnDetails;
        this.importDetails = importDetails;
    }

    public int getCopyId() {
        return copyId;
    }

    public void setCopyId(int copyId) {
        this.copyId = copyId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCopyCondition() {
        return copyCondition;
    }

    public void setCopyCondition(String copyCondition) {
        this.copyCondition = copyCondition;
    }

    public LoanDetail8[] getLoanDetails() {
        return loanDetails;
    }

    public void setLoanDetails(LoanDetail8[] loanDetails) {
        this.loanDetails = loanDetails;
    }

    public ReturnDetail8[] getReturnDetails() {
        return returnDetails;
    }

    public void setReturnDetails(ReturnDetail8[] returnDetails) {
        this.returnDetails = returnDetails;
    }

    public ImportDetail8[] getImportDetails() {
        return importDetails;
    }

    public void setImportDetails(ImportDetail8[] importDetails) {
        this.importDetails = importDetails;
    }
}
