package be.bruggeman.cv;

import java.io.File;
import javax.xml.XMLConstants;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

public class XmlValidator {
    public static void main(String[] args) {
        XmlValidator validator = new XmlValidator();
        validator.validate(args[0], args[1]);
    }

    private void validate(String xsdFilename, String xmlFilename) {
        try {
            SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
            javax.xml.validation.Schema schema = factory.newSchema(new File(xsdFilename));
            Validator validator = schema.newValidator();
            validator.validate(new StreamSource(new File(xmlFilename)));
            System.exit(0);
        } catch (Exception e) {
            System.err.println("XML is invalid: " + e);
            System.exit(1);
        }
    }
}
