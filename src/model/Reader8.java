package model;

public class Reader8 extends User8 {
    private int readerId;
    private String readerStatus;
    private LibraryCard8 libraryCard;
    private LoanRecord8[] loanRecords;

    public Reader8() {
    }

    public Reader8(int readerId, String readerStatus, LibraryCard8 libraryCard,
                   LoanRecord8[] loanRecords) {
        this.readerId = readerId;
        this.readerStatus = readerStatus;
        this.libraryCard = libraryCard;
        this.loanRecords = loanRecords;
    }

    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
    }

    public String getReaderStatus() {
        return readerStatus;
    }

    public void setReaderStatus(String readerStatus) {
        this.readerStatus = readerStatus;
    }

    public LibraryCard8 getLibraryCard() {
        return libraryCard;
    }

    public void setLibraryCard(LibraryCard8 libraryCard) {
        this.libraryCard = libraryCard;
    }

    public LoanRecord8[] getLoanRecords() {
        return loanRecords;
    }

    public void setLoanRecords(LoanRecord8[] loanRecords) {
        this.loanRecords = loanRecords;
    }
}
