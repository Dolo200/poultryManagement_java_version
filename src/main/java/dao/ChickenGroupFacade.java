/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import models.ChickenGroup;

/**
 *
 * @author Administrator
 */
@Stateless
public class ChickenGroupFacade extends AbstractFacade<ChickenGroup> {

    @PersistenceContext(unitName = "my_persistence_unit")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ChickenGroupFacade() {
        super(ChickenGroup.class);
    }
    
    public List<ChickenGroup> findByFarmIds(List<BigDecimal> farmIds) {
    if (farmIds == null || farmIds.isEmpty()) return Collections.emptyList();
    return getEntityManager()
            .createNamedQuery("ChickenGroup.findByFarmIds", ChickenGroup.class)
            .setParameter("farmIds", farmIds)
            .getResultList();
}
    
}
