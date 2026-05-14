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
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.math.BigDecimal;

/**
 *
 * @author Administrator
 */
@Entity
@Table(name = "COMMUNITY_CHAT")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "CommunityChat.findAll", query = "SELECT c FROM CommunityChat c"),
    @NamedQuery(name = "CommunityChat.findById", query = "SELECT c FROM CommunityChat c WHERE c.id = :id"),
    @NamedQuery(name = "CommunityChat.findByMessage", query = "SELECT c FROM CommunityChat c WHERE c.message = :message"),
    @NamedQuery(name = "CommunityChat.findByReaction", query = "SELECT c FROM CommunityChat c WHERE c.reaction = :reaction"),
    @NamedQuery(name = "CommunityChat.findByUserComment", query = "SELECT c FROM CommunityChat c WHERE c.userComment = :userComment")})
public class CommunityChat implements Serializable {

    private static final long serialVersionUID = 1L;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "ID")
    private BigDecimal id;
    @Size(max = 255)
    @Column(name = "MESSAGE")
    private String message;
    @Size(max = 100)
    @Column(name = "REACTION")
    private String reaction;
    @Size(max = 255)
    @Column(name = "USER_COMMENT")
    private String userComment;
    @JoinColumn(name = "USER_ID", referencedColumnName = "ID")
    @ManyToOne
    private Users userId;

    public CommunityChat() {
    }

    public CommunityChat(BigDecimal id) {
        this.id = id;
    }

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getReaction() {
        return reaction;
    }

    public void setReaction(String reaction) {
        this.reaction = reaction;
    }

    public String getUserComment() {
        return userComment;
    }

    public void setUserComment(String userComment) {
        this.userComment = userComment;
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
        if (!(object instanceof CommunityChat)) {
            return false;
        }
        CommunityChat other = (CommunityChat) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.CommunityChat[ id=" + id + " ]";
    }
    
}
