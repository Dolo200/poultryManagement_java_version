package models;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "VACCINATION")
@NamedQueries({
    @NamedQuery(name = "Vaccination.findAll", query = "SELECT v FROM Vaccination v"),
    @NamedQuery(name = "Vaccination.findById", query = "SELECT v FROM Vaccination v WHERE v.id = :id"),
    @NamedQuery(name = "Vaccination.findByChickenGroup", query = "SELECT v FROM Vaccination v WHERE v.chickenGroup.id = :groupId"),
    @NamedQuery(name = "Vaccination.findByChickenGroupIds", query = "SELECT v FROM Vaccination v WHERE v.chickenGroup.id IN :ids")
})
public class Vaccination implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "vaccination_seq")
    @SequenceGenerator(name = "vaccination_seq", sequenceName = "vaccination_seq", allocationSize = 1)
    @Column(name = "ID")
    private BigDecimal id;

    @Column(name = "DATE_GIVEN")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateGiven;          // when the vaccine was actually administered

    @Size(max = 100)
    @Column(name = "VACCINE")
    private String vaccine;          // kept for backward compatibility

    @Size(max = 100)
    @Column(name = "VACCINE_NAME")
    private String vaccineName;      // name of the vaccine

    @Size(max = 100)
    @Column(name = "DISEASE")
    private String disease;          // target disease

    @Column(name = "DUE_DATE")
    @Temporal(TemporalType.DATE)
    private Date dueDate;            // planned date of administration

    @Size(max = 20)
    @Column(name = "STATUS")
    private String status = "pending"; // pending / done

    @Column(name = "DONE_DATE")
    @Temporal(TemporalType.DATE)
    private Date doneDate;           // date when marked as done

    @Column(name = "ALERT_ACTIVE")
    private Boolean alertActive = true;

    @Column(name = "REMINDER_DAYS")
    private Integer reminderDays = 14;

    @Column(name = "AGE_DAYS")
    private Integer ageDays;         // recommended age (in days) for this vaccine

    @ManyToOne
    @JoinColumn(name = "CHICKEN_GROUP_ID", referencedColumnName = "ID")
    private ChickenGroup chickenGroup;

    public Vaccination() {}

    // Getters and setters for all fields
    public BigDecimal getId() { return id; }
    public void setId(BigDecimal id) { this.id = id; }
    public Date getDateGiven() { return dateGiven; }
    public void setDateGiven(Date dateGiven) { this.dateGiven = dateGiven; }
    public String getVaccine() { return vaccine; }
    public void setVaccine(String vaccine) { this.vaccine = vaccine; }
    public String getVaccineName() { return vaccineName; }
    public void setVaccineName(String vaccineName) { this.vaccineName = vaccineName; }
    public String getDisease() { return disease; }
    public void setDisease(String disease) { this.disease = disease; }
    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getDoneDate() { return doneDate; }
    public void setDoneDate(Date doneDate) { this.doneDate = doneDate; }
    public Boolean getAlertActive() { return alertActive; }
    public void setAlertActive(Boolean alertActive) { this.alertActive = alertActive; }
    public Integer getReminderDays() { return reminderDays; }
    public void setReminderDays(Integer reminderDays) { this.reminderDays = reminderDays; }
    public Integer getAgeDays() { return ageDays; }
    public void setAgeDays(Integer ageDays) { this.ageDays = ageDays; }
    public ChickenGroup getChickenGroup() { return chickenGroup; }
    public void setChickenGroup(ChickenGroup chickenGroup) { this.chickenGroup = chickenGroup; }

    @Override
    public int hashCode() { return id != null ? id.hashCode() : 0; }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof Vaccination)) return false;
        Vaccination other = (Vaccination) object;
        return (this.id == null && other.id == null) || (this.id != null && this.id.equals(other.id));
    }
}