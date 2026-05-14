/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.math.BigDecimal;
import java.math.BigInteger;

/**
 *
 * @author Administrator
 */
@Entity
@Table(name = "AI_CHAT")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "AiChat.findAll", query = "SELECT a FROM AiChat a"),
    @NamedQuery(name = "AiChat.findById", query = "SELECT a FROM AiChat a WHERE a.id = :id"),
    @NamedQuery(name = "AiChat.findByChickenGroupId", query = "SELECT a FROM AiChat a WHERE a.chickenGroupId = :chickenGroupId"),
    @NamedQuery(name = "AiChat.findByFarmId", query = "SELECT a FROM AiChat a WHERE a.farmId = :farmId"),
    @NamedQuery(name = "AiChat.findByQuestion", query = "SELECT a FROM AiChat a WHERE a.question = :question")})
public class AiChat implements Serializable {

    private static final long serialVersionUID = 1L;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "ID")
    private BigDecimal id;
    @Column(name = "CHICKEN_GROUP_ID")
    private BigInteger chickenGroupId;
    @Column(name = "FARM_ID")
    private BigInteger farmId;
    @Size(max = 255)
    @Column(name = "QUESTION")
    private String question;
    @Lob
    @Column(name = "ANSWER")
    private String answer;
    @JoinColumn(name = "USER_ID", referencedColumnName = "ID")
    @ManyToOne
    private Users userId;

    public AiChat() {
    }

    public AiChat(BigDecimal id) {
        this.id = id;
    }

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public BigInteger getChickenGroupId() {
        return chickenGroupId;
    }

    public void setChickenGroupId(BigInteger chickenGroupId) {
        this.chickenGroupId = chickenGroupId;
    }

    public BigInteger getFarmId() {
        return farmId;
    }

    public void setFarmId(BigInteger farmId) {
        this.farmId = farmId;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof AiChat)) {
            return false;
        }
        AiChat other = (AiChat) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.AiChat[ id=" + id + " ]";
    }
    
}
