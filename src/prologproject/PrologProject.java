
package prologproject;
import org.jpl7.*;
        
/**
 *
 * @author jevaughnferguson
 */
public class PrologProject {

    public static void main(String[] args) {
        
        Query q1 = new Query("consult('test cases/Group Work.pl')");
       
        if(q1.hasSolution()){
            System.out.println("consult('test cases/Group Work.pl') compiled successfully");
        }
        new PrologUI().setVisible(true);
    }
    
}
