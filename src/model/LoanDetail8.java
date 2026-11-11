package model;

public class LoanDetail8 {
    private int loanDetailId;
    private int copyId;

    public LoanDetail8() {
    }

    public LoanDetail8(int loanDetailId, int copyId) {
        this.loanDetailId = loanDetailId;
        this.copyId = copyId;
    }

    public int getLoanDetailId() {
        return loanDetailId;
    }

    public void setLoanDetailId(int loanDetailId) {
        this.loanDetailId = loanDetailId;
    }

    public int getCopyId() {
        return copyId;
    }

    public void setCopyId(int copyId) {
        this.copyId = copyId;
    }
}
