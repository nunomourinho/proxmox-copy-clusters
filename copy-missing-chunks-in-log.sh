#!/bin/bash

# Função para extrair os hashes de chunks ausentes de um arquivo de log
read_missing_chunks() {
    local log_file="$1"
    local missing_chunks=()
    
    # Ler o arquivo de log e capturar os hashes usando uma expressão regular
    while IFS= read -r line; do
        if [[ $line =~ chunk\ ([a-fA-F0-9]{64}) ]]; then
            chunk_hash="${BASH_REMATCH[1]}"
            # Adiciona o hash à lista se ainda não estiver nela
            if [[ ! " ${missing_chunks[@]} " =~ " ${chunk_hash} " ]]; then
                missing_chunks+=("$chunk_hash")
            fi
        fi
    done < "$log_file"
    
    echo "${missing_chunks[@]}"
}

# Função para copiar os chunks para a pasta de destino
copy_chunks() {
    local missing_chunks=("$@")
    local chunks_folder="${missing_chunks[0]}"
    local output_folder="${missing_chunks[1]}"
    unset missing_chunks[0]
    unset missing_chunks[1]
    
    for chunk_hash in "${missing_chunks[@]}"; do
        subfolder="${chunk_hash:0:4}"
        source_path="$chunks_folder/$subfolder/$chunk_hash"
        
        if [[ -f "$source_path" ]]; then
            destination_path="$output_folder/$subfolder"
            mkdir -p "$destination_path"
            cp "$source_path" "$destination_path"
            echo "Copied $chunk_hash to $destination_path"
        else
            echo "Chunk $chunk_hash not found at $source_path"
        fi
    done
}

# Função principal
main() {
    local log_file=""
    local chunks_folder=""
    local output_folder=""
    
    # Parse argumentos da linha de comando
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --log) log_file="$2"; shift ;;
            --chunks) chunks_folder="$2"; shift ;;
            --output) output_folder="$2"; shift ;;
            *) echo "Unknown parameter passed: $1"; exit 1 ;;
        esac
        shift
    done
    
    if [[ -z "$log_file" || -z "$chunks_folder" || -z "$output_folder" ]]; then
        echo "Usage: $0 --log <log_file> --chunks <chunks_folder> --output <output_folder>"
        exit 1
    fi

    # Lê os chunks ausentes
    missing_chunks=$(read_missing_chunks "$log_file")
    IFS=' ' read -r -a missing_chunks_array <<< "$missing_chunks"

    # Copia os chunks para o destino
    copy_chunks "$chunks_folder" "$output_folder" "${missing_chunks_array[@]}"
}

# Executa o script
main "$@"
