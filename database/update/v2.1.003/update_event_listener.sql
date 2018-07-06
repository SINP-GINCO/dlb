DELETE FROM metadata.event_listener ;

INSERT INTO metadata.event_listener(listener_id, classname) VALUES
    ('GincoChecksDSRService','fr.ifn.ogam.integration.business.ChecksDSRGincoService'),
    ('JddDlbService', 'fr.ifn.ogam.integration.business.JddDlbService'),
    ('GeoAssociationService', 'fr.ifn.ogam.integration.business.GeoAssociationService')
;