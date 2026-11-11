package model;

import java.util.Date;

public class FineRecord8 {
    private int fineRecordId;
    private Date fineDate;
    private String reason;
    private double fineAmount;
    private String status;

    public FineRecord8() {
    }

    public FineRecord8(int fineRecordId, Date fineDate, String reason,
                       double fineAmount, String status) {
        this.fineRecordId = fineRecordId;
        this.fineDate = fineDate;
        this.reason = reason;
        this.fineAmount = fineAmount;
        this.status = status;
    }

    public int getFineRecordId() {
        return fineRecordId;
    }

    public void setFineRecordId(int fineRecordId) {
        this.fineRecordId = fineRecordId;
    }

    public Date getFineDate() {
        return fineDate;
    }

    public void setFineDate(Date fineDate) {
        this.fineDate = fineDate;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public double getFineAmount() {
        return fineAmount;
    }

    public void setFineAmount(double fineAmount) {
        this.fineAmount = fineAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
