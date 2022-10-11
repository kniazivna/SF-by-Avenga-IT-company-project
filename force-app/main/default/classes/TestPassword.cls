public class TestPassword {
    public String secretMessage = 'covfefe';
    public void revealMessage (String password) {
        if (isPasswordCorrect(password)) {
            System.debug(secretMessage);
        } 
    }
    private  Boolean isPasswordCorrect (String password) {
        return password == 'qwerty';    }
}