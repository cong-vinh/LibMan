package model;

import java.util.Date;

public class ImportRecord8 {
    private int importRecordId;
    private Date importDate;
    private ImportDetail8[] importDetails;

    public ImportRecord8() {
    }

    public ImportRecord8(int importRecordId, Date importDate,
                         ImportDetail8[] importDetails) {
        this.importRecordId = importRecordId;
        this.importDate = importDate;
        this.importDetails = importDetails;
    }

    public int getImportRecordId() {
        return importRecordId;
    }

    public void setImportRecordId(int importRecordId) {
        this.importRecordId = importRecordId;
    }

    public Date getImportDate() {
        return importDate;
    }

    public void setImportDate(Date importDate) {
        this.importDate = importDate;
    }

    public ImportDetail8[] getImportDetails() {
        return importDetails;
    }

    public void setImportDetails(ImportDetail8[] importDetails) {
        this.importDetails = importDetails;
    }
}
