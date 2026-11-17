package br.com.escola.model;

/**
 * Aluno.java
 * JavaBean puro - sem anotacao, sem ORM, sem nada.
 * Era assim que se fazia: classe burra com get/set.
 * Equivalente a linha $linha = mysqli_fetch_row($res) do PHP.
 */
public class Aluno {

    private int    id;
    private String nome;
    private int    nivel;

    // Construtor vazio obrigatorio pro JavaBean funcionar com JSP
    public Aluno() {}

    public Aluno(int id, String nome, int nivel) {
        this.id    = id;
        this.nome  = nome;
        this.nivel = nivel;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getNivel() {
        return nivel;
    }

    public void setNivel(int nivel) {
        this.nivel = nivel;
    }

    /**
     * Converte o numero do nivel pro texto - igual o switch do PHP.
     */
    public String getNivelTexto() {
        switch (nivel) {
            case 1: return "Ed. Basica";
            case 2: return "Ens. Fundamental";
            case 3: return "Ensino Medio";
            case 4: return "Tecnico";
            default: return "Desconhecido";
        }
    }
}
