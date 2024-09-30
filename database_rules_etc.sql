USE `serviceorder`;

------------------
-- RULES/CHECKS --
------------------

-- O hash da senha não pode ser menor nem maior que 64 caracteres
ALTER TABLE Usuario
ADD CONSTRAINT CHK_PASSWORD CHECK (CHAR_LENGTH(`senhaHash`) = 64);

-- O preço do serviço não pode ser menor que 0 (zero)
ALTER TABLE Servico
ADD CONSTRAINT CHK_PRECO CHECK (preco >= 0);

-- Check para validar o email do usuario
ALTER TABLE Usuario
ADD CONSTRAINT CHK_EMAILUSUARIO CHECK (emailUsuario LIKE '%_@_%._%');

-- Check para validar o email do cliente
ALTER TABLE Cliente
ADD CONSTRAINT CHK_EMAILCLIENTE CHECK (emailCliente LIKE '%_@_%._%' OR emailCliente IS NULL OR emailCliente = '');

-- Check para validar se o status da ordem é algum dos quatro abaixo
ALTER TABLE Ordens
ADD CONSTRAINT CHK_STATUS_ORDENS CHECK (status IN ('Em aberto', 'Em andamento', 'Concluída', 'Cancelada'));

-- Check para validaer se o status do cliente é ativo ou inativo
ALTER TABLE Cliente
ADD CONSTRAINT CHK_STATUS_CLIENTE CHECK (status IN ('Ativo', 'Inativo'));

---------------------
-- VALORES DEFAULT --
---------------------

-- Data de criação é a atual do sistema por padrão
ALTER TABLE Usuario
ALTER dataCriacao SET DEFAULT (CURRENT_TIMESTAMP());

-- Preço padrão é 0 (zero)
ALTER TABLE Servico
ALTER preco SET DEFAULT 0;

-- Data de abertura é a data atual do sistema
ALTER TABLE Ordens
ALTER dataAbertura SET DEFAULT (CURRENT_TIMESTAMP());

-- Por padrão o status da Ordem é "Em aberto"
ALTER TABLE Ordens
ALTER status SET DEFAULT 'Em aberto';

-- Por padrão o status do cliente é "Ativo"
ALTER TABLE Cliente
ALTER status SET DEFAULT 'Ativo';

-- A alteração recebe como valor padrão a data atual do sistema
ALTER TABLE Historico
ALTER dataModificacao SET DEFAULT (CURRENT_TIMESTAMP());

-----------------------------------------
-- CAMPOS CALCULADOS/GENERATED COLUMNS --
-----------------------------------------

-- O campo enderecoCompleto é calculado usando a concatenação dos campos endereco, num endereco e bairro
ALTER TABLE Cliente
ADD enderecoCompleto VARCHAR(710) GENERATED ALWAYS AS (CONCAT(endereco, ', ', numEndereco, ', ', bairro, ', ', complemento)) STORED;

-----------
-- VIEWS --
-----------

-- Uma view para facilitar a leitura de dados das ordens
CREATE VIEW Vw_OrdensClientes AS
SELECT o.idOrdens, o.dataAbertura, o.dataConclusao, o.status, c.nomeCliente, c.telefonePrincipal, u.nomeUsuario, u.idUsuario
FROM Ordens o
JOIN Cliente c ON o.idClienteFK = c.idCliente
JOIN Usuario u ON o.idUsuarioFK = u.idUsuario;

-- Uma view para facilitar a visualização do histórico
CREATE VIEW Vw_HistoricoOrdens AS
SELECT h.idHistorico, h.dataModificacao, h.statusAnterior, h.statusNovo, o.idOrdens, h.idUsuarioFK
FROM Historico h
JOIN Ordens o ON h.idOrdensFK = o.idOrdens;

-- Uma view para visualizar os serviços atrelados as ordens
CREATE VIEW Vw_ServicosPorOrdem AS
SELECT 
    so.idServicosOrdem AS idSO,
    so.idOrdensFK AS idOrdem,
    s.nomeServico,
    s.preco
FROM 
    ServicosOrdem so
JOIN 
    Servico s ON so.idServicoFK = s.idServico;

--------------
-- TRIGGERS --
--------------

DELIMITER $$
CREATE TRIGGER trg_AttHistorico
AFTER UPDATE ON Ordens
FOR EACH ROW
BEGIN
	IF NEW.status != OLD.status THEN
		INSERT INTO Historico(statusAnterior, statusNovo, idOrdensFK, idUsuarioFK)
		VALUES(OLD.status, NEW.status, OLD.idOrdens, OLD.idUsuarioFK);
	END IF;
END$$
DELIMITER ;

-----------------------
-- STORED PROCEDURES --
-----------------------

-- Procedure para procurar ordens pelo nome dos clientes:
DELIMITER $$
CREATE PROCEDURE Pc_BuscaOrdens (IN NomeCliente VARCHAR(200))
BEGIN
	SELECT o.dataAbertura, o.dataConclusao, o.status, o.descricaoOrdem, o.laudoOrdem, c.nomeCliente, u.nomeUsuario
    FROM Ordens o
    JOIN Cliente c ON o.idClienteFK = c.idCliente
    JOIN Usuario u ON o.idUsuarioFK = u.idUsuario
    WHERE c.nomeCliente LIKE CONCAT('%', NomeCliente, '%');
END $$
DELIMITER ;

-- Procedure para criar clientes de forma simplificada
DELIMITER $$
CREATE PROCEDURE Pc_CriaCliente (
	IN p_idUsuario INT,
	IN p_nomeCliente VARCHAR(200),
    IN p_telefonePrincipal VARCHAR(15),
    IN p_telefoneSecundario VARCHAR(15),
    IN p_emailCliente VARCHAR(200),
    IN p_endereco VARCHAR(400),
    IN p_numEndereco VARCHAR(10),
    IN p_bairro VARCHAR(200),
    IN p_complemento VARCHAR(100))
BEGIN
	INSERT INTO Cliente(nomeCliente, telefonePrincipal, telefoneSecundario, emailCliente, endereco, numEndereco, bairro, complemento, idUsuarioFK)
    VALUES (p_nomeCliente, p_telefonePrincipal, p_telefoneSecundario, p_emailCliente, p_endereco, p_numEndereco, p_bairro, p_complemento, p_idUsuario);
END $$
DELIMITER ;

-- Procedure para atualizar clientes
DELIMITER $$
CREATE PROCEDURE Pc_AtualizaCliente (
	IN p_idCliente INT,
	IN p_nomeCliente VARCHAR(200),
    IN p_telefonePrincipal VARCHAR(15),
    IN p_telefoneSecundario VARCHAR(15),
    IN p_emailCliente VARCHAR(200),
    IN p_endereco VARCHAR(400),
    IN p_numEndereco VARCHAR(10),
    IN p_bairro VARCHAR(200),
    IN p_complemento VARCHAR(100))
BEGIN
	UPDATE Cliente 
    SET nomeCliente = p_nomeCliente, telefonePrincipal = p_telefonePrincipal, telefoneSecundario = p_telefoneSecundario,
    emailCliente = p_emailCliente, endereco = p_endereco, numEndereco = p_numEndereco, bairro = p_bairro, complemento = p_complemento
    WHERE idCliente = p_idCliente; 
END $$
DELIMITER ;

-- Procedure para criar usuários
DELIMITER $$
CREATE PROCEDURE Pc_CriaUser(
	IN p_nomeUsuario VARCHAR(200),
    IN p_emailUsuario VARCHAR(200),
    IN p_senhaHash VARCHAR(64))
BEGIN
	INSERT INTO Usuario(nomeUsuario, emailUsuario, senhaHash)
    VALUES(p_nomeUsuario, p_emailUsuario, p_senhaHash);
END $$
DELIMITER ;

-- Procedure para criar ordens
DELIMITER $$
CREATE PROCEDURE Pc_CriaOrdem(
	IN p_idUsuario INT,
    IN p_idCliente INT,
    IN p_descricao VARCHAR(1000)
)
BEGIN
	INSERT INTO Ordens(idUsuarioFK, idClienteFK, descricaoOrdem)
    VALUES(p_idUsuario, p_idCliente, p_descricao);
END $$
DELIMITER ;

-- Procedure para atualizar a ordem
DELIMITER $$
CREATE PROCEDURE Pc_AtualizaOrdem(
    IN p_idOrdem INT,
	IN p_idCliente INT,
    IN p_descricao VARCHAR(1000),
    IN p_laudo VARCHAR(1000),
    IN p_status VARCHAR(45),
    IN p_dataConclusao DATETIME
    )
BEGIN
	UPDATE Ordens SET idClienteFK = p_idCliente, descricaoOrdem = p_descricao, laudoOrdem = p_laudo, status = p_status, dataConclusao = p_dataConclusao WHERE idOrdens = p_idOrdem;
END $$
DELIMITER ;

-- Procedure para criar serviços
DELIMITER $$
CREATE PROCEDURE Pc_CriaServico(
	IN p_idUsuario INT,
	IN p_nomeServico VARCHAR(200),
    IN p_descricaoServico VARCHAR(500),
    IN p_preco DECIMAL(10,2)
    )
BEGIN
	INSERT INTO Servico(nomeServico, descricaoServico, preco, idUsuarioFK)
    VALUES (p_nomeServico, p_descricaoServico, p_preco, p_idUsuario);
END $$
DELIMITER ;

-- Procedure para atualizar serviços
DELIMITER $$
CREATE PROCEDURE Pc_AtualizaServico(
	IN p_idServico INT,
	IN p_nomeServico VARCHAR(200),
    IN p_descricaoServico VARCHAR(500),
    IN p_preco DECIMAL(10,2)
    )
BEGIN
	UPDATE Servico SET nomeServico = p_nomeServico, descricaoServico = p_descricaoServico, preco = p_preco WHERE idServico = p_idServico;
END $$
DELIMITER ;

-- Procedure para adicionar serviços nas ordens:
DELIMITER $$

CREATE PROCEDURE sp_AdicionarServicoOrdem (
    IN p_idOrdens INT,
    IN p_idServico INT
)
BEGIN
    -- Verifica se a ordem existe
    IF (SELECT COUNT(*) FROM Ordens WHERE idOrdens = p_idOrdens) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A ordem especificada não existe.';
    END IF;

    -- Verifica se o serviço existe
    IF (SELECT COUNT(*) FROM Servico WHERE idServico = p_idServico) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O serviço especificado não existe.';
    END IF;

    -- Verifica se o serviço já está associado à ordem
    IF (SELECT COUNT(*) FROM ServicosOrdem WHERE idOrdensFK = p_idOrdens AND idServicoFK = p_idServico) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Este serviço já está associado a esta ordem.';
    END IF;

    -- Insere o serviço na ordem
    INSERT INTO ServicosOrdem (idOrdensFK, idServicoFK)
    VALUES (p_idOrdens, p_idServico);
    
    -- Atualiza o valor total da ordem
    UPDATE Ordens
    SET valorTotal = (SELECT fc_CalculaPrecoTotalOrdem(p_idOrdens))
    WHERE idOrdens = p_idOrdens;
    
END $$

DELIMITER ;

---------------
-- FUNCTIONS --
---------------

-- Function para calcular o valor total da ordem
DELIMITER $$
CREATE FUNCTION fc_CalculaPrecoTotalOrdem (p_idOrdens INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_total DECIMAL(10,2);
  SELECT SUM(s.preco) INTO v_total
  FROM ServicosOrdem so
  JOIN Servico s ON so.idServicoFK = s.idServico
  WHERE so.idOrdensFK = p_idOrdens;
  RETURN IFNULL(v_total, 0.00);
END $$
DELIMITER ;

-- Function para validar login
DELIMITER $$
CREATE FUNCTION fc_ValidaLogin (f_email VARCHAR(200), f_senhaHash VARCHAR(64))
RETURNS BOOL
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_senhaHash VARCHAR(64);
    SELECT senhaHash INTO v_senhaHash FROM Usuario WHERE emailUsuario = f_email;
    IF(v_senhaHash = f_senhaHash) THEN RETURN true;
    ELSE RETURN false;
    END IF;
END $$
DELIMITER ;
