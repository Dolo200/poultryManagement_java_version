/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import models.FarmStaff;
import models.Users;

/**
 *
 * @author Administrator
 */
@Stateless
public class FarmStaffFacade extends AbstractFacade<FarmStaff> {

    @PersistenceContext(unitName = "my_persistence_unit")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public FarmStaffFacade() {
        super(FarmStaff.class);
    }
    
   public List<FarmStaff> findByStaff(Users staff) {
        return em.createNamedQuery("FarmStaff.findByStaffId", FarmStaff.class)
                 .setParameter("staffId", staff)
                 .getResultList();
    }
    

    
}
