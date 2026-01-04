document.getElementById('fileInput').addEventListener('change', function () {
    const file = this.files[0];

    if (!file) {
        return;
    }

    const reader = new FileReader();

    reader.onload = function (event) {
        const conteudo = event.target.result;

        // Divide o texto linha a linha
        const linhas = conteudo.split(/\r?\n/);

        // Exemplo: mostrar cada linha
        const resultado = document.getElementById('resultado');
        resultado.textContent = '';

        linhas.forEach((linha, index) => {
            if (linha.trim() !== '') {
                resultado.textContent += `Linha ${index + 1}: ${linha}\n`;
                console.log(linha); // também disponível no console
            }
        });
    };

    reader.readAsText(file);
});
