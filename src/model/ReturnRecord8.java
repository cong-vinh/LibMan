package model;

import java.util.Date;

public class ReturnRecord8 {
    private int returnRecordId;
    private Date returnDate;
    private ReturnDetail8[] returnDetails;

    public ReturnRecord8() {
    }

    public ReturnRecord8(int returnRecordId, Date returnDate,
                         ReturnDetail8[] returnDetails) {
        this.returnRecordId = returnRecordId;
        this.returnDate = returnDate;
        this.returnDetails = returnDetails;
    }

    public int getReturnRecordId() {
        return returnRecordId;
    }

    public void setReturnRecordId(int returnRecordId) {
        this.returnRecordId = returnRecordId;
    }

    public Date getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(Date returnDate) {
        this.returnDate = returnDate;
    }

    public ReturnDetail8[] getReturnDetails() {
        return returnDetails;
    }

    public void setReturnDetails(ReturnDetail8[] returnDetails) {
        this.returnDetails = returnDetails;
    }
}
