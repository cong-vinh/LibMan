package model;

import java.util.Date;

public class LibraryCard8 {
    private int cardId;
    private Date issueDate;
    private Date expiryDate;
    private String status;

    public LibraryCard8() {
    }

    public LibraryCard8(int cardId, Date issueDate, Date expiryDate, String status) {
        this.cardId = cardId;
        this.issueDate = issueDate;
        this.expiryDate = expiryDate;
        this.status = status;
    }

    public int getCardId() {
        return cardId;
    }

    public void setCardId(int cardId) {
        this.cardId = cardId;
    }

    public Date getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(Date issueDate) {
        this.issueDate = issueDate;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
