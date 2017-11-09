package fr.ifn.ogam.integration.business;

import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;

import org.apache.log4j.Logger;
import org.apache.commons.lang3.StringUtils;

import fr.ifn.ogam.common.database.GenericData;
import fr.ifn.ogam.common.database.rawdata.JddDAO;
import fr.ifn.ogam.common.util.DSRConstants;
import fr.ifn.ogam.common.business.checks.CheckException;
import static fr.ifn.ogam.common.business.checks.CheckCodesGinco.*;
import static fr.ifn.ogam.common.business.UnitTypes.*;

/**
 * Service used to perform specific DLB treatments for jdd.
 *
 * @author gpastakia
 *
 */
public class JddDlbService extends JddService implements IntegrationEventListener {

	/***
	 * The logger used to log the errors or several information.**
	 *
	 * @see org.apache.log4j.Logger
	 */
	private final transient Logger logger = Logger.getLogger(this.getClass());
	
	/**
	 * The DAO
	 */
	private JddDAO jddDAO = new JddDAO();
	
	/**
	 * The metadata Id
	 */
	private Integer tpsId;
	
	/**
	 * Event called before the integration of a submission of data.
	 * Get the tpsId from submissionId
	 *
	 * @param submissionId
	 *            the submission identifier
	 * @throws Exception
	 *             in case of database error
	 */
	public void beforeIntegration(Integer submissionId) throws Exception {
		super.beforeIntegration(submissionId);
		// todo
		logger.debug("JddService get tpsId");
		tpsId = jddDAO.getTpsId(submissionId);

	}

	/**
	 * Event called after the integration of a submission of data.
	 *
	 * @param submissionId
	 *            the submission identifier
	 * @throws Exception
	 *             in case of database error
	 */
	public void afterIntegration(Integer submissionId) throws Exception {
		super.afterIntegration(submissionId);
		// DO NOTHING ELSE FOR NOW
	}

	/**
	 * Event called before each insertion of a line of data. Add or Update the field 'tpsid' for the data in the Java map given.
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @param values
	 *            Entry values
	 * @throws Exception,
	 *             CheckException CheckException in case of database error
	 */
	public void beforeLineInsertion(Integer submissionId, Map<String, GenericData> values) throws Exception, CheckException {
		super.beforeLineInsertion(submissionId, values);
		logger.debug("JddDlbService insert tpsId in data");

		GenericData tpsIdGD = new GenericData();
		tpsIdGD.setColumnName(DSRConstants.TPS_ID);
		tpsIdGD.setType("INTEGER");
		// Set the format
		for (GenericData gd : values.values()) {
			if (gd.getFormat() != null) {
				tpsIdGD.setFormat(gd.getFormat());
				break;
			}
		}
		tpsIdGD.setValue(tpsId);

		values.put(DSRConstants.TPS_ID, tpsIdGD);
	}

	/**
	 * 
	 * Event called after each insertion of a line of data.
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @param format
	 *            The format
	 * @param tableName
	 *            The table name
	 * @param values
	 *            Entry values
	 * @param id
	 *            The identifier corresponding to the ogamId
	 * @throws Exception
	 *             in case of database error
	 */
	public void afterLineInsertion(Integer submissionId, String format, String tableName, Map<String, GenericData> values, String id) throws Exception{
		super.afterLineInsertion(submissionId, format, tableName, values, id);
		// DO NOTHING ELSE FOR NOW
	}
}
