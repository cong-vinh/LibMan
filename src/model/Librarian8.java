package model;

public class Librarian8 extends User8 {
    private int employeeId;
    private LoanRecord8[] loanRecords;
    private ReturnRecord8[] returnRecords;
    private ImportRecord8[] importRecords;

    public Librarian8() {
    }

    public Librarian8(int employeeId, LoanRecord8[] loanRecords,
                      ReturnRecord8[] returnRecords, ImportRecord8[] importRecords) {
        this.employeeId = employeeId;
        this.loanRecords = loanRecords;
        this.returnRecords = returnRecords;
        this.importRecords = importRecords;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public LoanRecord8[] getLoanRecords() {
        return loanRecords;
    }

    public void setLoanRecords(LoanRecord8[] loanRecords) {
        this.loanRecords = loanRecords;
    }

    public ReturnRecord8[] getReturnRecords() {
        return returnRecords;
    }

    public void setReturnRecords(ReturnRecord8[] returnRecords) {
        this.returnRecords = returnRecords;
    }

    public ImportRecord8[] getImportRecords() {
        return importRecords;
    }

    public void setImportRecords(ImportRecord8[] importRecords) {
        this.importRecords = importRecords;
    }
}
