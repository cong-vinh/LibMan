package model;

public class Manager8 extends User8 {
    private int employeeId;

    public Manager8() {
    }

    public Manager8(int employeeId) {
        this.employeeId = employeeId;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }
}
