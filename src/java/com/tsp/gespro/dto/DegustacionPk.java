/*
 * This source file was generated by FireStorm/DAO.
 * 
 * If you purchase a full license for FireStorm/DAO you can customize this header file.
 * 
 * For more information please visit http://www.codefutures.com/products/firestorm
 */

package com.tsp.gespro.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/** 
 * This class represents the primary key of the degustacion table.
 */
public class DegustacionPk implements Serializable
{
	protected int idDegustacion;

	/** 
	 * This attribute represents whether the primitive attribute idDegustacion is null.
	 */
	protected boolean idDegustacionNull;

	/** 
	 * Sets the value of idDegustacion
	 */
	public void setIdDegustacion(int idDegustacion)
	{
		this.idDegustacion = idDegustacion;
	}

	/** 
	 * Gets the value of idDegustacion
	 */
	public int getIdDegustacion()
	{
		return idDegustacion;
	}

	/**
	 * Method 'DegustacionPk'
	 * 
	 */
	public DegustacionPk()
	{
	}

	/**
	 * Method 'DegustacionPk'
	 * 
	 * @param idDegustacion
	 */
	public DegustacionPk(final int idDegustacion)
	{
		this.idDegustacion = idDegustacion;
	}

	/** 
	 * Sets the value of idDegustacionNull
	 */
	public void setIdDegustacionNull(boolean idDegustacionNull)
	{
		this.idDegustacionNull = idDegustacionNull;
	}

	/** 
	 * Gets the value of idDegustacionNull
	 */
	public boolean isIdDegustacionNull()
	{
		return idDegustacionNull;
	}

	/**
	 * Method 'equals'
	 * 
	 * @param _other
	 * @return boolean
	 */
	public boolean equals(Object _other)
	{
		if (_other == null) {
			return false;
		}
		
		if (_other == this) {
			return true;
		}
		
		if (!(_other instanceof DegustacionPk)) {
			return false;
		}
		
		final DegustacionPk _cast = (DegustacionPk) _other;
		if (idDegustacion != _cast.idDegustacion) {
			return false;
		}
		
		if (idDegustacionNull != _cast.idDegustacionNull) {
			return false;
		}
		
		return true;
	}

	/**
	 * Method 'hashCode'
	 * 
	 * @return int
	 */
	public int hashCode()
	{
		int _hashCode = 0;
		_hashCode = 29 * _hashCode + idDegustacion;
		_hashCode = 29 * _hashCode + (idDegustacionNull ? 1 : 0);
		return _hashCode;
	}

	/**
	 * Method 'toString'
	 * 
	 * @return String
	 */
	public String toString()
	{
		StringBuffer ret = new StringBuffer();
		ret.append( "com.tsp.gespro.dto.DegustacionPk: " );
		ret.append( "idDegustacion=" + idDegustacion );
		return ret.toString();
	}

}
