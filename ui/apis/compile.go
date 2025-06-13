package apis

import (
	"encoding/json"
	"io"
	"net/http"
	"strings"

	"github.com/ArturC03/r2d2"
	_ "github.com/ArturC03/r2d2/errors"
)

// Estrutura para receber o JSON
type CompileRequest struct {
	Code string `json:"code"`
}

// Estrutura para responder com JSON
type CompileResponse struct {
	Success bool   `json:"success"`
	Result  string `json:"result"`
	Error   any    `json:"error"`
}

func Compile(w http.ResponseWriter, r *http.Request) {
	// Definir o Content-Type da resposta
	w.Header().Set("Content-Type", "application/json")

	// Verificar se o método é POST
	if r.Method != http.MethodPost {
		w.WriteHeader(http.StatusMethodNotAllowed)
		json.NewEncoder(w).Encode(CompileResponse{
			Success: false,
			Error:   "Method not allowed",
		})
		return
	}

	// Ler o corpo da requisição
	body, err := io.ReadAll(r.Body)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(CompileResponse{
			Success: false,
			Error:   "Failed to read request body",
		})
		return
	}
	defer r.Body.Close()

	// Fazer o parse do JSON
	var req CompileRequest
	if err := json.Unmarshal(body, &req); err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(CompileResponse{
			Success: false,
			Error:   "Invalid JSON format",
		})
		return
	}

	// Verificar se o código foi fornecido
	if strings.Trim(req.Code, " ") == "" {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(CompileResponse{
			Success: false,
			Error:   "Code field is required",
		})
		return
	}

	// Compilar o código
	jsCode, errorCollector := r2d2.BuildJSCode(req.Code)

	if errorCollector.HasErrors() {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(CompileResponse{
			Success: false,
			Error:   errorCollector.Errors,
		})
		return
	}

	// Responder com sucesso
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(CompileResponse{
		Success: true,
		Result:  jsCode,
	})
}
