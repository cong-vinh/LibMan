package model;

public class Supplier8 {
    private int supplierId;
    private String name;
    private String address;
    private String phoneNumber;
    private String email;
    private String description;
    private ImportRecord8[] importRecords;

    public Supplier8() {
    }

    public Supplier8(int supplierId, String name, String address,
                     String phoneNumber, String email, String description,
                     ImportRecord8[] importRecords) {
        this.supplierId = supplierId;
        this.name = name;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.description = description;
        this.importRecords = importRecords;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public ImportRecord8[] getImportRecords() {
        return importRecords;
    }

    public void setImportRecords(ImportRecord8[] importRecords) {
        this.importRecords = importRecords;
    }
}
