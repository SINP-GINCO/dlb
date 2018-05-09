DELETE FROM metadata.event_listener ;

INSERT INTO metadata.event_listener(listener_id, classname) VALUES
    ('GincoChecksDSRService','fr.ifn.ogam.integration.business.ChecksDSRGincoService'),
    ('JddService','fr.ifn.ogam.integration.business.JddService'),
    ('GeoAssociationService','fr.ifn.ogam.integration.business.GeoAssociationService')
;

