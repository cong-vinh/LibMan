package model;

import java.util.Date;

public class ReaderBorrowStatistics8 extends Reader8 {
    private int numberOfBorrows;
    private Date fromDate;
    private Date toDate;

    public ReaderBorrowStatistics8() {
    }

    public ReaderBorrowStatistics8(int numberOfBorrows, Date fromDate, Date toDate) {
        this.numberOfBorrows = numberOfBorrows;
        this.fromDate = fromDate;
        this.toDate = toDate;
    }

    public int getNumberOfBorrows() {
        return numberOfBorrows;
    }

    public void setNumberOfBorrows(int numberOfBorrows) {
        this.numberOfBorrows = numberOfBorrows;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }

    public Date getToDate() {
        return toDate;
    }

    public void setToDate(Date toDate) {
        this.toDate = toDate;
    }
}
