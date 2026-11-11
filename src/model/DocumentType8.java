package model;

public class DocumentType8 {
    private int documentTypeId;
    private String title;
    private String author;
    private String publisher;
    private int publicationYear;
    private String description;
    private DocumentTypeCopy8[] copies;

    public DocumentType8() {
    }

    public DocumentType8(int documentTypeId, String title, String author,
                         String publisher, int publicationYear, String description,
                         DocumentTypeCopy8[] copies) {
        this.documentTypeId = documentTypeId;
        this.title = title;
        this.author = author;
        this.publisher = publisher;
        this.publicationYear = publicationYear;
        this.description = description;
        this.copies = copies;
    }

    public int getDocumentTypeId() {
        return documentTypeId;
    }

    public void setDocumentTypeId(int documentTypeId) {
        this.documentTypeId = documentTypeId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public int getPublicationYear() {
        return publicationYear;
    }

    public void setPublicationYear(int publicationYear) {
        this.publicationYear = publicationYear;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public DocumentTypeCopy8[] getCopies() {
        return copies;
    }

    public void setCopies(DocumentTypeCopy8[] copies) {
        this.copies = copies;
    }
}
