CREATE SCHEMA IF NOT EXISTS `serviceorder` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `serviceorder` ;

-- -----------------------------------------------------
-- Table `serviceorder`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `serviceorder`.`Usuario` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT,
  `nomeUsuario` VARCHAR(200) NOT NULL,
  `emailUsuario` VARCHAR(200) NOT NULL,
  `senhaHash` VARCHAR(256) NOT NULL,
  `dataCriacao` DATETIME NOT NULL DEFAULT now(),
  PRIMARY KEY (`idUsuario`),
  UNIQUE INDEX `idUsuario_UNIQUE` (`idUsuario` ASC) VISIBLE,
  UNIQUE INDEX `emailUsuario_UNIQUE` (`emailUsuario` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `serviceorder`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `serviceorder`.`Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `nomeCliente` VARCHAR(200) NOT NULL,
  `telefonePrincipal` VARCHAR(15) NOT NULL,
  `telefoneSecundario` VARCHAR(15) NULL DEFAULT NULL,
  `emailCliente` VARCHAR(200) NULL DEFAULT NULL,
  `endereco` VARCHAR(400) NOT NULL,
  `numEndereco` VARCHAR(10) NOT NULL,
  `bairro` VARCHAR(200) NOT NULL,
  `status` VARCHAR(45) NOT NULL DEFAULT 'Ativo',
  `idUsuarioFK` INT NOT NULL,
  `complemento` VARCHAR(100) NULL DEFAULT NULL,
  `enderecoCompleto` VARCHAR(710) GENERATED ALWAYS AS (concat(`endereco`,_utf8mb4', ',`numEndereco`,_utf8mb4', ',`bairro`,_utf8mb4', ',`complemento`)) STORED,
  PRIMARY KEY (`idCliente`),
  UNIQUE INDEX `idCliente_UNIQUE` (`idCliente` ASC) VISIBLE,
  INDEX `fk_Cliente_Usuario1_idx` (`idUsuarioFK` ASC) VISIBLE,
  CONSTRAINT `fk_Cliente_Usuario1`
    FOREIGN KEY (`idUsuarioFK`)
    REFERENCES `serviceorder`.`Usuario` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `serviceorder`.`Ordens`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `serviceorder`.`Ordens` (
  `idOrdens` INT NOT NULL AUTO_INCREMENT,
  `idUsuarioFK` INT NOT NULL,
  `idClienteFK` INT NOT NULL,
  `dataAbertura` DATETIME NOT NULL DEFAULT now(),
  `dataConclusao` DATETIME NULL DEFAULT NULL,
  `status` VARCHAR(45) NOT NULL DEFAULT 'Em aberto',
  `descricaoOrdem` VARCHAR(1000) NOT NULL,
  `valorTotal` DECIMAL(10,2) NULL DEFAULT '0.00',
  `laudoOrdem` VARCHAR(1000) NULL DEFAULT NULL,
  PRIMARY KEY (`idOrdens`),
  UNIQUE INDEX `idOrdens_UNIQUE` (`idOrdens` ASC) VISIBLE,
  INDEX `fk_Ordens_Usuario_idx` (`idUsuarioFK` ASC) VISIBLE,
  INDEX `fk_Ordens_Cliente1_idx` (`idClienteFK` ASC) VISIBLE,
  CONSTRAINT `fk_Ordens_Cliente1`
    FOREIGN KEY (`idClienteFK`)
    REFERENCES `serviceorder`.`Cliente` (`idCliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Ordens_Usuario`
    FOREIGN KEY (`idUsuarioFK`)
    REFERENCES `serviceorder`.`Usuario` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `serviceorder`.`Historico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `serviceorder`.`Historico` (
  `idHistorico` INT NOT NULL AUTO_INCREMENT,
  `dataModificacao` DATETIME NOT NULL DEFAULT now(),
  `statusAnterior` VARCHAR(45) NOT NULL,
  `statusNovo` VARCHAR(45) NOT NULL,
  `idOrdensFK` INT NOT NULL,
  `idUsuarioFK` INT NOT NULL,
  PRIMARY KEY (`idHistorico`),
  UNIQUE INDEX `idHistorico_UNIQUE` (`idHistorico` ASC) VISIBLE,
  INDEX `fk_Historico_Ordens1_idx` (`idOrdensFK` ASC) VISIBLE,
  INDEX `fk_Historico_Usuario1_idx` (`idUsuarioFK` ASC) VISIBLE,
  CONSTRAINT `fk_Historico_Ordens1`
    FOREIGN KEY (`idOrdensFK`)
    REFERENCES `serviceorder`.`Ordens` (`idOrdens`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Historico_Usuario1`
    FOREIGN KEY (`idUsuarioFK`)
    REFERENCES `serviceorder`.`Usuario` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `serviceorder`.`Servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `serviceorder`.`Servico` (
  `idServico` INT NOT NULL AUTO_INCREMENT,
  `nomeServico` VARCHAR(200) NOT NULL,
  `descricaoServico` VARCHAR(500) NULL DEFAULT NULL,
  `preco` DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  `idUsuarioFK` INT NOT NULL,
  PRIMARY KEY (`idServico`),
  UNIQUE INDEX `idServico_UNIQUE` (`idServico` ASC) VISIBLE,
  INDEX `fk_Servico_Usuario1_idx` (`idUsuarioFK` ASC) VISIBLE,
  CONSTRAINT `fk_Servico_Usuario1`
    FOREIGN KEY (`idUsuarioFK`)
    REFERENCES `serviceorder`.`Usuario` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `serviceorder`.`ServicosOrdem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `serviceorder`.`ServicosOrdem` (
  `idServicosOrdem` INT NOT NULL AUTO_INCREMENT,
  `idOrdensFK` INT NOT NULL,
  `idServicoFK` INT NOT NULL,
  PRIMARY KEY (`idServicosOrdem`),
  UNIQUE INDEX `idServicosOrdem_UNIQUE` (`idServicosOrdem` ASC) VISIBLE,
  INDEX `fk_ServicosOrdem_Ordens1_idx` (`idOrdensFK` ASC) VISIBLE,
  INDEX `fk_ServicosOrdem_Servico1_idx` (`idServicoFK` ASC) VISIBLE,
  CONSTRAINT `fk_ServicosOrdem_Ordens1`
    FOREIGN KEY (`idOrdensFK`)
    REFERENCES `serviceorder`.`Ordens` (`idOrdens`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ServicosOrdem_Servico1`
    FOREIGN KEY (`idServicoFK`)
    REFERENCES `serviceorder`.`Servico` (`idServico`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `serviceorder` ;

-- -----------------------------------------------------
-- Placeholder table for view `serviceorder`.`vw_historicoordens`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `serviceorder`.`vw_historicoordens` (`idHistorico` INT, `dataModificacao` INT, `statusAnterior` INT, `statusNovo` INT, `idOrdens` INT, `idUsuarioFK` INT);

-- -----------------------------------------------------
-- Placeholder table for view `serviceorder`.`vw_ordensclientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `serviceorder`.`vw_ordensclientes` (`idOrdens` INT, `dataAbertura` INT, `dataConclusao` INT, `status` INT, `nomeCliente` INT, `telefonePrincipal` INT, `nomeUsuario` INT, `idUsuario` INT);

-- -----------------------------------------------------
-- Placeholder table for view `serviceorder`.`vw_servicosporordem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `serviceorder`.`vw_servicosporordem` (`idSO` INT, `idOrdem` INT, `nomeServico` INT, `preco` INT);

-- -----------------------------------------------------
-- procedure Pc_AtualizaCliente
-- -----------------------------------------------------

DELIMITER $$
USE `serviceorder`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Pc_AtualizaCliente`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Pc_AtualizaOrdem
-- -----------------------------------------------------

DELIMITER $$
USE `serviceorder`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Pc_AtualizaOrdem`(
    IN p_idOrdem INT,
	IN p_idCliente INT,
    IN p_descricao VARCHAR(1000),
    IN p_laudo VARCHAR(1000),
    IN p_status VARCHAR(45),
    IN p_dataConclusao DATETIME
    )
BEGIN
	UPDATE Ordens SET idClienteFK = p_idCliente, descricaoOrdem = p_descricao, laudoOrdem = p_laudo, status = p_status, dataConclusao = p_dataConclusao WHERE idOrdens = p_idOrdem;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Pc_AtualizaServico
-- -----------------------------------------------------

DELIMITER $$
USE `serviceorder`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Pc_AtualizaServico`(
	IN p_idServico INT,
	IN p_nomeServico VARCHAR(200),
    IN p_descricaoServico VARCHAR(500),
    IN p_preco DECIMAL(10,2)
    )
BEGIN
	UPDATE Servico SET nomeServico = p_nomeServico, descricaoServico = p_descricaoServico, preco = p_preco WHERE idServico = p_idServico;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Pc_BuscaOrdens
-- -----------------------------------------------------

DELIMITER $$
USE `serviceorder`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Pc_BuscaOrdens`(IN NomeCliente VARCHAR(200))
BEGIN
	SELECT o.dataAbertura, o.dataConclusao, o.status, o.descricaoOrdem, o.laudoOrdem, c.nomeCliente, u.nomeUsuario
    FROM Ordens o
    JOIN Cliente c ON o.idClienteFK = c.idCliente
    JOIN Usuario u ON o.idUsuarioFK = u.idUsuario
    WHERE c.nomeCliente LIKE CONCAT('%', NomeCliente, '%');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Pc_CriaCliente
-- -----------------------------------------------------

DELIMITER $$
USE `serviceorder`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Pc_CriaCliente`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Pc_CriaOrdem
-- -----------------------------------------------------

DELIMITER $$
USE `serviceorder`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Pc_CriaOrdem`(
	IN p_idUsuario INT,
    IN p_idCliente INT,
    IN p_descricao VARCHAR(1000)
)
BEGIN
	INSERT INTO Ordens(idUsuarioFK, idClienteFK, descricaoOrdem)
    VALUES(p_idUsuario, p_idCliente, p_descricao);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Pc_CriaServico
-- -----------------------------------------------------

DELIMITER $$
USE `serviceorder`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Pc_CriaServico`(
	IN p_idUsuario INT,
	IN p_nomeServico VARCHAR(200),
    IN p_descricaoServico VARCHAR(500),
    IN p_preco DECIMAL(10,2)
    )
BEGIN
	INSERT INTO Servico(nomeServico, descricaoServico, preco, idUsuarioFK)
    VALUES (p_nomeServico, p_descricaoServico, p_preco, p_idUsuario);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Pc_CriaUser
-- -----------------------------------------------------

DELIMITER $$
USE `serviceorder`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Pc_CriaUser`(
	IN p_nomeUsuario VARCHAR(200),
    IN p_emailUsuario VARCHAR(200),
    IN p_senhaHash VARCHAR(64))
BEGIN
	INSERT INTO Usuario(nomeUsuario, emailUsuario, senhaHash)
    VALUES(p_nomeUsuario, p_emailUsuario, p_senhaHash);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function fc_CalculaPrecoTotalOrdem
-- -----------------------------------------------------

DELIMITER $$
USE `serviceorder`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fc_CalculaPrecoTotalOrdem`(p_idOrdens INT) RETURNS decimal(10,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
  DECLARE v_total DECIMAL(10,2);
  SELECT SUM(s.preco) INTO v_total
  FROM ServicosOrdem so
  JOIN Servico s ON so.idServicoFK = s.idServico
  WHERE so.idOrdensFK = p_idOrdens;
  RETURN IFNULL(v_total, 0.00);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function fc_ValidaLogin
-- -----------------------------------------------------

DELIMITER $$
USE `serviceorder`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fc_ValidaLogin`(f_email VARCHAR(200), f_senhaHash VARCHAR(64)) RETURNS tinyint(1)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_senhaHash VARCHAR(64);
    SELECT senhaHash INTO v_senhaHash FROM Usuario WHERE emailUsuario = f_email;
    IF(v_senhaHash = f_senhaHash) THEN RETURN true;
    ELSE RETURN false;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_AdicionarServicoOrdem
-- -----------------------------------------------------

DELIMITER $$
USE `serviceorder`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AdicionarServicoOrdem`(
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
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `serviceorder`.`vw_historicoordens`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `serviceorder`.`vw_historicoordens`;
USE `serviceorder`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `serviceorder`.`vw_historicoordens` AS select `h`.`idHistorico` AS `idHistorico`,`h`.`dataModificacao` AS `dataModificacao`,`h`.`statusAnterior` AS `statusAnterior`,`h`.`statusNovo` AS `statusNovo`,`o`.`idOrdens` AS `idOrdens`,`h`.`idUsuarioFK` AS `idUsuarioFK` from (`serviceorder`.`historico` `h` join `serviceorder`.`ordens` `o` on((`h`.`idOrdensFK` = `o`.`idOrdens`)));

-- -----------------------------------------------------
-- View `serviceorder`.`vw_ordensclientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `serviceorder`.`vw_ordensclientes`;
USE `serviceorder`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `serviceorder`.`vw_ordensclientes` AS select `o`.`idOrdens` AS `idOrdens`,`o`.`dataAbertura` AS `dataAbertura`,`o`.`dataConclusao` AS `dataConclusao`,`o`.`status` AS `status`,`c`.`nomeCliente` AS `nomeCliente`,`c`.`telefonePrincipal` AS `telefonePrincipal`,`u`.`nomeUsuario` AS `nomeUsuario`,`u`.`idUsuario` AS `idUsuario` from ((`serviceorder`.`ordens` `o` join `serviceorder`.`cliente` `c` on((`o`.`idClienteFK` = `c`.`idCliente`))) join `serviceorder`.`usuario` `u` on((`o`.`idUsuarioFK` = `u`.`idUsuario`)));

-- -----------------------------------------------------
-- View `serviceorder`.`vw_servicosporordem`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `serviceorder`.`vw_servicosporordem`;
USE `serviceorder`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `serviceorder`.`vw_servicosporordem` AS select `so`.`idServicosOrdem` AS `idSO`,`so`.`idOrdensFK` AS `idOrdem`,`s`.`nomeServico` AS `nomeServico`,`s`.`preco` AS `preco` from (`serviceorder`.`servicosordem` `so` join `serviceorder`.`servico` `s` on((`so`.`idServicoFK` = `s`.`idServico`)));

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `serviceorder`;

DELIMITER $$
USE `serviceorder`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `serviceorder`.`trg_AttHistorico`
AFTER UPDATE ON `serviceorder`.`Ordens`
FOR EACH ROW
BEGIN
	IF NEW.status != OLD.status THEN
		INSERT INTO Historico(statusAnterior, statusNovo, idOrdensFK, idUsuarioFK)
		VALUES(OLD.status, NEW.status, OLD.idOrdens, OLD.idUsuarioFK);
	END IF;
END$$


DELIMITER ;
