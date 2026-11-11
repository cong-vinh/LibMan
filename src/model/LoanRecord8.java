package model;

import java.util.Date;

public class LoanRecord8 {
    private int loanRecordId;
    private Date loanDate;
    private String status;
    private LoanDetail8[] loanDetails;

    public LoanRecord8() {
    }

    public LoanRecord8(int loanRecordId, Date loanDate, String status,
                       LoanDetail8[] loanDetails) {
        this.loanRecordId = loanRecordId;
        this.loanDate = loanDate;
        this.status = status;
        this.loanDetails = loanDetails;
    }

    public int getLoanRecordId() {
        return loanRecordId;
    }

    public void setLoanRecordId(int loanRecordId) {
        this.loanRecordId = loanRecordId;
    }

    public Date getLoanDate() {
        return loanDate;
    }

    public void setLoanDate(Date loanDate) {
        this.loanDate = loanDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LoanDetail8[] getLoanDetails() {
        return loanDetails;
    }

    public void setLoanDetails(LoanDetail8[] loanDetails) {
        this.loanDetails = loanDetails;
    }
}
